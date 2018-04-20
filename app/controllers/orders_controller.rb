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
  end

  def destroy #this clears the cart before order has gone into paid status
  end
end
