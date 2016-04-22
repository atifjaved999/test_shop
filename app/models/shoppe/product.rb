require 'roo'
require 'globalize'

module Shoppe
  class Product < ActiveRecord::Base
    self.table_name = 'shoppe_products'

    # Add dependencies for products
    require_dependency 'shoppe/product/product_attributes'
    require_dependency 'shoppe/product/variants'

    # Attachments for this product
    has_many :attachments, as: :parent, dependent: :destroy, autosave: true, class_name: 'Shoppe::Attachment'

    # The product's categorizations
    #
    # @return [Shoppe::ProductCategorization]
    has_many :product_categorizations, dependent: :destroy, class_name: 'Shoppe::ProductCategorization', inverse_of: :product
    # The product's categories
    #
    # @return [Shoppe::ProductCategory]
    has_many :product_categories, class_name: 'Shoppe::ProductCategory', through: :product_categorizations

    # The product's tax rate
    #
    # @return [Shoppe::TaxRate]
    belongs_to :tax_rate, class_name: 'Shoppe::TaxRate'

    # Ordered items which are associated with this product
    has_many :order_items, dependent: :restrict_with_exception, class_name: 'Shoppe::OrderItem', as: :ordered_item

    # Orders which have ordered this product
    has_many :orders, through: :order_items, class_name: 'Shoppe::Order'

    # Stock level adjustments for this product
    has_many :stock_level_adjustments, dependent: :destroy, class_name: 'Shoppe::StockLevelAdjustment', as: :item

    # Validations
    with_options if: proc { |p| p.parent.nil? } do |product|
      product.validate :has_at_least_one_product_category
      product.validates :description, presence: true
      product.validates :short_description, presence: true
    end
    validates :name, presence: true
    validates :permalink, presence: true, uniqueness: true, permalink: true
    validates :sku, presence: true
    validates :weight, numericality: true
    validates :price, numericality: true
    validates :cost_price, numericality: true, allow_blank: true

    # Before validation, set the permalink if we don't already have one
    before_validation { self.permalink = name.parameterize if permalink.blank? && name.is_a?(String) }

    # All active products
    scope :active, -> { where(active: true) }

    scope :default, -> { where(default: true) }

    # All featured products
    scope :featured, -> { where(featured: true) }

    scope :only_variants, -> { where.not(parent_id: nil) }

    # Localisations
    translates :name, :permalink, :description, :short_description
    scope :ordered, -> { includes(:translations).order(:name) }

    def attachments=(attrs)
      if attrs['default_image']['file'].present? then attachments.build(attrs['default_image']) end
      if attrs['data_sheet']['file'].present? then attachments.build(attrs['data_sheet']) end

      if attrs['extra']['file'].present? then attrs['extra']['file'].each { |attr| attachments.build(file: attr, parent_id: attrs['extra']['parent_id'], parent_type: attrs['extra']['parent_type']) } end
    end

    # Return the name of the product
    #
    # @return [String]
    def full_name
      parent ? "#{parent.name} (#{name})" : name
    end

    # Is this product orderable?
    #
    # @return [Boolean]
    def orderable?
      return false unless active?
      return false if has_variants?
      true
    end

    # The price for the product
    #
    # @return [BigDecimal]
    def price
      # self.default_variant ? self.default_variant.price : read_attribute(:price)
      default_variant ? default_variant.price : read_attribute(:price)
    end

    # Is this product currently in stock?
    #
    # @return [Boolean]
    def in_stock?
      default_variant ? default_variant.in_stock? : (stock_control? ? stock > 0 : true)
    end

    # Return the total number of items currently in stock
    #
    # @return [Fixnum]
    def stock
      stock_level_adjustments.sum(:adjustment)
    end

    # Return the first product category
    #
    # @return [Shoppe::ProductCategory]
    def product_category
      product_categories.first
    rescue
      nil
    end

    # Return attachment for the default_image role
    #
    # @return [String]
    def default_image
      attachments.for('default_image')
    end

    # Set attachment for the default_image role
    def default_image_file=(file)
      attachments.build(file: file, role: 'default_image')
    end

    # Return attachment for the data_sheet role
    #
    # @return [String]
    def data_sheet
      attachments.for('data_sheet')
    end

    # Search for products which include the given attributes and return an active record
    # scope of these products. Chainable with other scopes and with_attributes methods.
    # For example:
    #
    #   Shoppe::Product.active.with_attribute('Manufacturer', 'Apple').with_attribute('Model', ['Macbook', 'iPhone'])
    #
    # @return [Enumerable]
    def self.with_attributes(key, values)
      product_ids = Shoppe::ProductAttribute.searchable.where(key: key, value: values).pluck(:product_id).uniq
      where(id: product_ids)
    end

    # Imports products from a spreadsheet file
    # Example:
    #
    #   Shoppe:Product.import("path/to/file.csv")
    def self.import(file)
      spreadsheet = open_spreadsheet(file)
      spreadsheet.default_sheet = spreadsheet.sheets.first
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]

        # Don't import products where the name is blank
        next if row['name'].nil?
        if product = where(name: row['name']).take
          # Dont import products with the same name but update quantities
          qty = row['qty'].to_i
          if qty > 0
            product.stock_level_adjustments.create!(description: I18n.t('shoppe.import'), adjustment: qty)
          end
        else
          product = new
          product.name = row['name']
          product.sku = row['sku']
          product.description = row['description']
          product.short_description = row['short_description']
          product.weight = row['weight']
          product.price = row['price'].nil? ? 0 : row['price']
          product.permalink = row['permalink']

          product.product_categories << begin
            if Shoppe::ProductCategory.where(name: row['category_name']).present?
              Shoppe::ProductCategory.where(name: row['category_name']).take
            else
              Shoppe::ProductCategory.create(name: row['category_name'])
            end
          end

          product.save!

          qty = row['qty'].to_i
          if qty > 0
            product.stock_level_adjustments.create!(description: I18n.t('shoppe.import'), adjustment: qty)
          end
        end
      end
    end

    def self.open_spreadsheet(file)
      case File.extname(file.original_filename)
      when '.csv' then Roo::CSV.new(file.path)
      when '.xls' then Roo::Excel.new(file.path)
      when '.xlsx' then Roo::Excelx.new(file.path)
      else fail I18n.t('shoppe.imports.errors.unknown_format', filename: File.original_filename)
      end
    end

    def get_color
      self.name.split("-")[0] || ""
    end

    def get_size
      self.name.split("-")[1] || ""
    end

    def collect_colors(variant_names)
      # variant_names = variant_names.collect(&:name)
      colors = []
      variant_names.each do |variant|
        colors << variant.get_color
      end
      return colors.uniq
    end

    def collect_sizes(variant_names)
      # variant_names = variant_names.collect(&:name)
      sizes = []
      variant_names.each do |variant|
        sizes << variant.get_size
      end
      return sizes.uniq
    end

    def color_variants(color)
      return self.parent.variants.joins(:translations).where("shoppe_product_translations.name like ?", "%#{color}%") if self.variant?
      return self.variants.joins(:translations).where("shoppe_product_translations.name like ?", "%#{color}%") if self.has_variants?
    end

    def available_colors
      return collect_colors(self.parent.variants) if self.variant?
      return collect_colors(self.variants) if self.has_variants?
    end

    # def available_sizes
    #   color = self.get_color
    #   size_variants = self.parent.variants.joins(:translations).where("shoppe_product_translations.name like ?", "%#{color}%") if color
    #   collect_sizes(size_variants) if size_variants
    # end


    def self.find_exact_product(color, size)
      name1 = [color, "-", size].join
      joins(:translations).where("shoppe_product_translations.name like ?", "%#{name1}%").try(:first)
    end

    def self.all_colors
      products = where.not(parent_id:nil).joins(:translations) # Colors from Variants
      colors = []
      products.each do |product|
        colors << product.get_color
      end
      return colors.uniq
    end

    def self.all_sizes
      products = where.not(parent_id:nil).joins(:translations) # Sizes from Variants
      sizes = []
      products.each do |product|
        sizes << product.get_size
      end
      return sizes.uniq
    end

    def self.search_by_color(color)
      joins(:translations).where("shoppe_product_translations.name like ?", "%#{color}%")
    end

    def self.search_by_size(size)
      joins(:translations).where("shoppe_product_translations.name like ?", "%#{size}%")
    end





#===========================================
    def self.default_variants
      where(default: true).where.not(parent_id:nil)
    end

    def self.search_filters(params)
      if params[:search_category].present?
        @products = Shoppe::ProductCategory.find(params[:search_category]).products
      else
        @products = Shoppe::Product.active
      end
        @products = @products.search_by_color(params[:search_color]) if params[:search_color].present?
        @products = @products.search_by_size(params[:search_size]) if params[:search_size].present?
        return @products
    end

    def self.without_parents
        parents = joins(:variants)
      if parents.present?
        parents_ids = parents.collect(&:id) 
        where.not(id:parents_ids)
      else
        active
      end
    end

    def get_short_description
      return  self.parent.short_description if self.variant?
      return self.short_description
    end

    def get_description
      return  self.parent.description if self.variant?
      return self.description
    end

    def get_product_attributes
      return  self.parent.product_attributes if self.variant?
      return self.product_attributes
    end

    def get_in_the_box
      return  self.parent.in_the_box if self.variant?
      return self.in_the_box
    end

    private

    # Validates

    def has_at_least_one_product_category
      errors.add(:base, 'must add at least one product category') if product_categories.blank?
    end
  end
end
