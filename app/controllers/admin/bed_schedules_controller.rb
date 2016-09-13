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
        querier = Admin::ShowCurrentCapacity.new
        querier.new_bed_schedule = service.bed_schedule
        querier.load_models
        @view_model = View::AdminShowCapacity.new(querier)
        render '/admin/capacities/show'
      end
    end
  end
end
