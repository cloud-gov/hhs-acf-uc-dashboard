class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Authorization

  rescue_from Authorization::Error do |exception|
    redirect_to dashboard_authorization_path
  end

  # Used by Devise after confirmation
  # Since we have a layer of authorization after authentication
  # this will redirect to the authorization layer
  def signed_in_root_path(*args)
    dashboard_authorization_path
  end
end
