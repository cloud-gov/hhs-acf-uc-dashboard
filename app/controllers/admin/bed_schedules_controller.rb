module Admin
  class BedSchedulesController < ApplicationController
    before_action :authenticate_user!

    def create
      require!(:can_admin)
      service = Admin::CreateBedSchedule.new(params[:bed_schedule])
      service.call
      service.add_flash(flash)
      if service.saved?
        redirect_to '/admin/capacities/current'
      else
        querier = Query::AdminCapacityDashboard.new
        querier.new_bed_schedule = service.bed_schedule
        querier.load_models
        @view_model = View::AdminShowCapacity.new(querier)
        render '/admin/capacities/show'
      end
    end

    def update
      require!(:can_admin)
      service = Admin::UpdateBedSchedule.new(params[:bed_schedule], params[:id])
      service.call
      service.add_flash(flash)
      if service.saved?
        redirect_to '/admin/capacities/current'
      else
        querier = Query::AdminCapacityDashboard.new
        querier.load_models
        querier.replace_bed_schedule(service.bed_schedule)
        @view_model = View::AdminShowCapacity.new(querier)
        render '/admin/capacities/show'
      end
    end
  end
end
