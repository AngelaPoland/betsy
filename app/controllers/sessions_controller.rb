class SessionsController < ApplicationController
  def login
    auth_hash = request.env['omniauth.auth']
  end

  def logout
  end
end
