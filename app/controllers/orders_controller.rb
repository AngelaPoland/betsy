class OrdersController < ApplicationController
  def show
  end

  def create
  end

  def update #when dealing with cart before checkout
  end

  def checkout #edit to enter billing info
  end

  def paid #submit after checkout
    if @current_cart.update(billing_params)
      @current_cart.order_products.each do |order_product|
        order_product.update_attributes(status: "paid")
      end
      @current_cart.update_attributes(status: "paid")
      flash[:success] = "Order received! Thank you for your purchase."
      session[:order_id] = Order.create.id
    elsif @current_cart.errors.any?
      flash.now[:error] = @current_cart.errors
      render :checkout
    else
      flash[:alert] = "Something went wrong, and we couldn't process your order."
      render :checkout
    end
  end

  def destroy #this clears the cart before order has gone into paid status
  end

  private

  def billing_params
    params.require(:order).permit(
      :billing_address,
      :billing_name,
      :billing_num,
      :billing_exp,
      :billing_cvv,
      :billing_zipcode
    )
  end
end
