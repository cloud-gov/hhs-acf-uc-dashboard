module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!

    def index
      require!(:can_manage_users)
      users = User.all
      @view_model = View::AdminUsers.new(users)
    end

    def update
      require!(:can_manage_users)
      user = User.find(params[:id])
      Admin::UserRole.new(user, params[:user]).update
      redirect_to admin_users_path
    end
  end
end
