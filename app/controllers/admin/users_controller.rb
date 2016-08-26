module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!

    def index
      require!(:can_manage_users)
      users = User.all
      @view_model = View::AdminUsers.new(users)
    end
  end
end
