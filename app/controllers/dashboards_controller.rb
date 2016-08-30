class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    redirect_to "/dashboards/default"
  end

  def show
    render Role.new(current_user).dashboard_template(params[:id]).to_s
  end
end
