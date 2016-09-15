class DailyReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    redirect_to Role.new(current_user).home_path
  end

  def show
    if Role.new(current_user).report_access?
      render :show
    else
      render :'no-access'
    end
  end
end
