class OrdersController < ApplicationController

  def index
  end

  def show
    @order = Order.find_by(id: params[:id])
    if @order.nil?
      flash[:alert] = "That order does not exist"
      redirect_back fallback_location: enter_order_path
    end
  end

  def update #when dealing with cart before checkout
    order_product = OrderProduct.find_by(id: params[:order_product][:order_product_id])
    if !order_product.nil?
      product = order_product.product
      new_quantity = params[:order_product][:quantity].to_i
      inventory_difference = new_quantity - order_product.quantity
      order_product.quantity = new_quantity
      product.inventory -= inventory_difference
      if !(new_quantity > product.inventory)
        if order_product.save && product.save
          flash[:success] = "Successfully updated quantity"
        else
          flash[:alert] = "Unable to update quantity"
        end
      else
        flash[:alert] = "Dee, is that you? You can't order more items than are available"
      end
    else
      flash[:alert] = "Earth Creature, that doesn't exist"
    end
    redirect_to cart_path
  end

  def checkout #edit to enter billing info
    order = Order.find_by(id: params[:id])
    if order.order_products.empty?
      flash[:alert] = "Uhh.... Your cart is having existential crisis. It's empty"
      redirect_to cart_path
    end
  end

  def paid #submit after checkout
    @order = Order.find_by(id: params[:id])
    if @order && ( @order.status == "pending" || @order.status.nil? )
      if @order.update(billing_params)
        @order.order_products.each do |order_product|
          order_product.update_attributes(status: "paid")
        end
        @order.status = "paid"
        if @order.save
          flash[:success] = "Order received! Thank you for your purchase."
          session[:order_id] = Order.create.id
          redirect_to order_path(@order.id)
        else
          flash.now[:error] = @order.errors
          render :checkout, status: :error
        end
      end
    else
      flash[:alert] = "Insufficient funds. Go crowdfund for more"
      redirect_to root_path
    end
  end

  def destroy #this clears the cart before order has gone into paid status
    order = Order.find_by(id: params[:id])
    count = 0
    if !order.nil?
      orders_count = order.order_products.count
      order.order_products.each do | order_product |
        product = order_product.product
        quantity = order_product.quantity
        product.inventory += quantity
        successful_destroy = order_product.destroy
        successful_save = product.save
        if successful_save && successful_destroy
          count += 1
        end
      end
      if count == orders_count
        flash[:success] = "Successfully emptied your Cart"
      else
        flash[:alert] = "Unable to empty your Cart at this time"
      end
    else
      flash[:alert] = "Umm that order doesn't exist bro."
    end
    redirect_to cart_path
  end

  def enter_order
  end

  def find_order
    id = params[:order][:id].to_i
    order = Order.find_by(id: id)
    if order
      flash[:success] = "Successfully found your Confirmation Order"
      redirect_to order_path(order.id)
    else
      flash[:alert] = "That Order does not exist"
      render :enter_order, status: :error
    end
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
      :billing_zipcode,
    )
  end
end
