class DailyReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    redirect_to Role.new(current_user).home_path
  end

  def show
    render Role.new(current_user).report_template(params[:id]).to_s
  end
end
