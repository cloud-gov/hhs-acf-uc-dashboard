class HomeController < ApplicationController
  def index
    redirect_to Role.new(current_user).home_path if current_user
  end
end
