class OrderProductsController < ApplicationController
  def edit
  end

  def update
    order_status = params[:status]
    @order_product = OrderProduct.find_by(id: params[:id])
    @order_product.update_attributes(status: order_status)
    redirect_to order_fulfillment_path
  end

  def destroy
    order_product = OrderProduct.find_by(id: params[:id])
    if order_product.destroy
      flash[:success] = "Successfully removed from Cart"
    else
      flash[:alert] = "Unable to delete from Cart at this moment"
    end
    redirect_to order_path(@current_cart.id)
  end
end
