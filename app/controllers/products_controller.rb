class ProductsController < ApplicationController
  protect_from_forgery
  def index
    @products = Shoppe::Product.root.ordered.includes(:product_categories, :variants)
    # @products = @products.group_by(&:product_category)
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
    
    if params[:colors] and params[:sizes]
      @product = Shoppe::Product.find_exact_product(params[:colors], params[:sizes])
    end

    quantity = params[:quantity] ? params[:quantity].to_i : 1
    current_order.order_items.add_item(@product, quantity)
    # redirect_to product_path(@product.permalink), :notice => "Product has been added successfuly!"
  end

end
