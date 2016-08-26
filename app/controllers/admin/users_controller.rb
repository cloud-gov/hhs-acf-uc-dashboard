module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!

    def index
      require!(:can_manage_users)
    end
  end
end
