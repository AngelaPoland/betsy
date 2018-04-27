class MerchantsController < ApplicationController

  before_action :require_login
  
  def account_page
    @total_net_revenue = []

    @total_orders = []
    @current_merchant.products.each do |product|
      product.order_products.each do |order_product|
        @total_orders << order_product
      end
    end

    @total_orders.each do |order_product|
      @total_net_revenue << order_product.product.price
    end

    @pending_totals = []

    @pending_orders = @total_orders.select { |order| order.status == "pending" }

    @pending_orders.each do |order_product|
      @pending_totals << order_product.product.price
    end


    @paid_totals = []

    @paid_orders = @total_orders.select { |order| order.status == "paid" }

    @paid_orders.each do |order_product|
      @paid_totals << order_product.product.price
    end

    @cancelled_totals = []

    @cancelled_orders = @total_orders.select { |order| order.status == "cancelled" }

    @cancelled_orders.each do |order_product|
      @cancelled_totals << order_product.product.price
    end

    @shipped_totals = []

    @shipped_orders = @total_orders.select { |order| order.status == "shipped" }

    @shipped_orders.each do |order_product|
      @shipped_totals << order_product.product.price
    end
  end



  def order_fulfillment
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
