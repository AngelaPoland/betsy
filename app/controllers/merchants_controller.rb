class MerchantsController < ApplicationController
  def index
  end

  def account_page #show - only visible by OAuth
    if !@current_merchant
      flash[:alert] = "You do not have access to this Merchant's account"
    end
  end

  def order_fulfillment
    if !@current_merchant
      flash[:alert] = "You do not have access to this Merchant's order page"
    end
  end

  def products_manager
    if !@current_merchant
      flash[:alert] = "You do not have access to this Merchant's product management"
    end
  end
end
