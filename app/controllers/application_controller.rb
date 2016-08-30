class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Authorization

  rescue_from Authorization::Error do
    redirect_to "/dashboards/default"
  end

  # Used by Devise after confirmation
  # Since we have a layer of authorization after authentication
  # this will redirect to the authorization layer
  def signed_in_root_path(*)
    Role.new(current_user).home_path
  end
end
