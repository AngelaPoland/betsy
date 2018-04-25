  class MerchantsController < ApplicationController

  def account_page #show - only visible by OAuth
    if !@current_merchant
      flash[:alert] = "You do not have access to this Merchant's account"
    end
  end

  def order_fulfillment
    if !@current_merchant
      flash[:alert] = "You do not have access to this Merchant's order page"
    else
      @order_products = []
      @current_merchant.products.each do |product|
        product.order_products.each do |order_product|
          @order_products << order_product
        end
      end
    end
  end

  def products_manager
    if !@current_merchant
      flash[:alert] = "You do not have access to this Merchant's product management"
    else
      @products = @current_merchant.products
    end
  end

end
