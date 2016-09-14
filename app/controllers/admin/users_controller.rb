module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!

    def index
      require!(:can_admin)
      users = User.all.order(:email)
      @view_model = View::AdminUsers.new(users)
    end

    def new
      require!(:can_admin)
      @view_model = View::AdminNewUser.new
    end

    def create
      require!(:can_admin)

      service = Admin::CreateUser.new(params[:user])
      service.call
      service.add_flash(flash)

      if service.saved?
        redirect_to admin_users_path
      else
        @view_model = View::AdminNewUser.new(service.model)
        render :new
      end
    end

    def update
      require!(:can_admin)
      user = User.find(params[:id])
      service = Admin::UpdateUserRole.new(user, params[:user])
      service.call
      service.add_flash(flash)
      redirect_to admin_users_path
    end
  end
end
