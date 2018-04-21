class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # before_action :require_login
  before_action :current_merchant

  def current_merchant
    @current_merchant = Merchant.find_by(id: session[:merchant_id]) 
  end

  def require_login
    if current_merchant.nil?
      flash[:error] = "You must be logged in to view this section"
      redirect_to session_path
    end
  end
end
