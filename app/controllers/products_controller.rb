class ProductsController < ApplicationController
  protect_from_forgery
  def index
    # byebug
    if params[:search_category].present? || params[:search_color].present? || params[:search_size].present?
      @products = Shoppe::Product.search_filters(params)
    else
      @products = Shoppe::Product.without_parents.active#.includes(:product_categories, :variants)#.page(params[:page]).per(4)
    end
    # @products = @products.group_by(&:product_category)
    @products = @products.page(params[:page]).per(8)
    @colors = Shoppe::Product.all_colors
    @sizes = Shoppe::Product.all_sizes

    if request.xhr?
      # render :partial=> 'products/products.html.erb'
      respond_to do |format|
        format.js {}
      end
    end
  end

  def show
    @product = Shoppe::Product.active.find_by_permalink(params[:permalink])

      if @product.has_variants?
        # Main
        @product = @product.default_variant # get default variant here
      end

      if @product.variant?
        # Variant
          if params[:color]
            @color_variants = @product.color_variants(params[:color])
            @product = @color_variants.first if @color_variants
          end
        @colors = @product.available_colors
        @sizes = @product.available_sizes
      end

    # byebug
    if request.xhr?
      respond_to do |format|
        format.js {}
      end
    end
  end

  def buy
    @product = Shoppe::Product.active.find_by_permalink!(params[:permalink])
    
    if params[:colors].present? and params[:sizes].present?
      @product = Shoppe::Product.find_exact_product(params[:colors], params[:sizes])
      # byebug # iff
    elsif params[:colors].present?
      @product = @product.color_variants(params[:colors]).first
      # byebug # else
    end

    quantity = params[:quantity] ? params[:quantity].to_i : 1
    # byebug
    current_order.order_items.add_item(@product, quantity)
    # redirect_to product_path(@product.permalink), :notice => "Product has been added successfuly!"
  end

end
