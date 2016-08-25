class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Used by Devise after confirmation
  # Since we have a layer of authorization after authentication
  # this will redirect to the authorization layer
  def signed_in_root_path(*args)
    dashboard_authorization_path
  end
end
