module Admin
  class CapacitiesController < ApplicationController
    before_action :authenticate_user!

    def index
      require!(:can_admin)
    end

    def show
      require!(:can_admin)
    end
  end
end
