module Admin
  class CapacitiesController < ApplicationController
    before_action :authenticate_user!

    def index
      require!(:can_admin)
    end

    def show
      require!(:can_admin)
      service = Admin::ShowCurrentCapacity.new
      service.load_models
      @view_model = View::AdminShowCapacity.new(service)
    end

    def update
      require!(:can_admin)

      service = Admin::UpdateCapacity.new(params[:id], params[:capacity], current_user)
      service.save
      service.add_flash(flash)

      if service.saved?
        redirect_to '/admin/capacities/current'
      else
        @view_model = View::AdminShowCapacity.new(service)
        render :show
      end
    end
  end
end
