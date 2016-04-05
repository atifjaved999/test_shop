class HomeController < ApplicationController
  def index
    @products = Shoppe::Product.limit(6)
  end

  def contact
    Shoppe::UserMailer.contact_us(params).deliver_now
    flash[:notice] = "An email has been sent successfully to Malu from you."
    redirect_to "/"
  end
end
