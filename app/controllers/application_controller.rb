class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :current_merchant

  def current_merchant
    @current_merchant ||= Merchant.find(session[:merchant_id]) if session[:merchant_id]
  end

  def render_404
    # DPR: this will actually render a 404 page in production
    raise ActionController::RoutingError.new('Not Found')
  end

end
