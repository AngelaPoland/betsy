class OrderProductsController < ApplicationController
  
  def update
    order_status = params[:status]
    @order_product = OrderProduct.find_by(id: params[:id])
    @order_product.update_attributes(status: order_status)
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
    redirect_to order_path(@current_cart.id)
  end
end
