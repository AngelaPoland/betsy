class OrderProductsController < ApplicationController
  def edit
  end

  def update
    order_status = params[:status]
    @order_product = OrderProduct.find_by(id: params[:id])
    @order_product.update_attributes(status: order_status)
    redirect_to order_fulfillment_path
  end
end
