
class OrderProductsController < ApplicationController

  before_action :require_login, only: [:update]

  def update
    valid_status = ["shipped", "cancelled"]
    order_status = params[:status]
    @order_product = OrderProduct.find_by(id: params[:id])
    if @order_product && order_status && valid_status.include?(order_status)
      if @order_product.merchant == @current_merchant
        @order_product.update_attributes(status: order_status)
        flash[:success] = "Successfully changed that order status"
      else
        flash[:alert] = "Not yours. You don't have that much power"
      end
    else
      flash[:alert] = "Something about that request doesn't exist"
    end
    redirect_to order_fulfillment_path
  end

  def destroy
    order_product = OrderProduct.find_by(id: params[:id])
    product = order_product.product
    if @current_cart.order_products.include?(order_product)
      quantity = order_product.quantity
      product.inventory += quantity

      if product.save && order_product.destroy
        flash[:success] = "Successfully removed from Cart"
      else
        flash[:alert] = "Unable to delete from Cart at this moment"
      end
    else
      flash[:alert] = "That doesn't exist in your Cart"
    end
    redirect_to cart_path
  end
end
