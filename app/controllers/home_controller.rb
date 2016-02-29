class HomeController < ApplicationController
  def index
    @products = Shoppe::Product.limit(6)
  end
end
