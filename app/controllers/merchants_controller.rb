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
      @merchant_orders = []
      if params[:status]
        order_products = OrderProduct.status(params[:status])
        order_products.each do | order_product |
          @order_products << order_product if order_product.merchant == @current_merchant
        end
      else
        @current_merchant.products.each do |product|
          product.order_products.each do |order_product|
            @order_products << order_product
          end
        end
      end
      @current_merchant.products.each do |product|
        product.order_products.each do |order_product|
          @merchant_orders << order_product
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
