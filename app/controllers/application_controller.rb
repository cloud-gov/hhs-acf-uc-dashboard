class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Authorization

  rescue_from Authorization::Error do
    redirect_to Role.new(current_user).home_path
  end
end
