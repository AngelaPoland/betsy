class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_merchant
    @current_merchant ||= Merchant.find(session[:merchant_id]) if session[:merchant_id]
  end

end
