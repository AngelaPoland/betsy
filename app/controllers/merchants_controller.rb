class MerchantsController < ApplicationController
  def account_page
    @total_orders = []
    @current_merchant.products.each do |product|
      product.order_products.each do |order_product|
        @total_orders << order_product
      end
    end

    @pending_orders = @total_orders.select { |order| order.status == "pending" }

    @paid_orders = @total_orders.select { |order| order.status == "paid" }

    @cancelled_orders = @total_orders.select { |order| order.status == "cancelled" }

    @shipped_orders = @total_orders.select { |order| order.status == "shipped" }

  end



  def order_fulfillment
    <<<<<<< HEAD
    @merchant_orders = []
    @current_merchant.products.each do |product|
      product.order_products.each do |order_product|
        @merchant_orders << order_product
      end
    end

    all_orders = OrderProduct.all
    filtered_orders = all_orders.status(params[:status])
    @order_products = []

    if params[:status].present?
      filtered_orders.each do |order_product|
        merchant = order_product.product.merchant
        if merchant == @current_merchant
          @order_products << order_product
        end
      end

    else
      all_orders.each do |order_product|
        merchant = order_product.product.merchant
        if merchant == @current_merchant
          @order_products << order_product
        end
      end
    end
  end

  def products_manager
    @products = @current_merchant.products
  end
end
