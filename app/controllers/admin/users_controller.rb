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

    def update
      require!(:can_admin)
      user = User.find(params[:id])
      Admin::UserRole.new(user, params[:user]).update
      flash[:success] = "Successfully changed role for #{user.email}."
      redirect_to admin_users_path
    end
  end
end
