class OrdersController < ApplicationController
  def show
    @order = Order.find_by(id: params[:id])
  end

  def update #when dealing with cart before checkout
    order_product = OrderProduct.find_by(id: params[:order_product][:order_product_id])
    product = order_product.product
    new_quantity = params[:order_product][:quantity]
    inventory_difference = new_quantity.to_i - order_product.quantity
    order_product.quantity = new_quantity
    product.inventory -= inventory_difference
    if order_product.save && product.save
      flash[:success] = "Sucessfully updated quantity"
    else
      flash[:alert] = "Unable to update quantity"
    end
    redirect_to order_path(@current_cart.id)
  end

  def checkout #edit to enter billing info
  end

  def paid #submit after checkout
    if @current_cart.update(billing_params)
      @current_cart.order_products.each do |order_product|
        order_product.update_attributes(status: "paid")
      end
      @current_cart.status = "paid"
      if @current_cart.save
        flash[:success] = "Order received! Thank you for your purchase."
        session[:order_id] = Order.create.id
      else
        flash.now[:error] = @current_cart.errors
        render :checkout
      end
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
      :billing_email,
      :billing_address,
      :billing_name,
      :billing_num,
      :billing_exp,
      :billing_cvv,
      :billing_zipcode
    )
  end
end
