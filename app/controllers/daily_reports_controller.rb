class DailyReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    redirect_to Role.new(current_user).home_path
  end

  def show
    role = Role.new(current_user)
    if role.report_access?
      querier = Query::DailyReport.new(role, params)
      querier.load_data
      @view_model = View::ShowDailyReport.new(querier)
      render :show
    else
      render :'no-access'
    end
  end
end
