class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery with: :exception

  before_action :current_merchant
  # before_action :current_cart

  def require_login
    if !@current_merchant
      flash[:alert] = "You need to be logged in."
      redirect_to root_path
    end
  end

  def confirm_current_merchant
    merchant = Merchant.find_by(id: params[:merchant_id])
    if @current_merchant != merchant
      flash[:alert] = "You do not have access to this merchant's account."
      redirect_back fallback_location: account_page_path
    end
  end

  def current_merchant
    @current_merchant ||= Merchant.find_by(id: session[:merchant_id])
  end

  def current_cart
    if session[:order_id]
      @current_cart = Order.find(session[:order_id])
    else
      @current_cart = Order.create
      session[:order_id] = @current_cart.id
    end
  end


  def render_404
    render file: "/public/404.html", status: 404
    # raise ActionController::RoutingError.new('Not Found')
  end

end
