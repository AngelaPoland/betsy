class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:create]

  def login
    auth_hash = request.env['omniauth.auth']
  end

  def logout
  end
end
