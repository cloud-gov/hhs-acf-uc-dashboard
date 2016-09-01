module Admin
  class UpdateUserRole
    attr_reader :user, :user_params

    def initialize(user, user_params)
      @user = user
      @user_params = user_params
    end

    def update
      user.update_attribute(:role, role)
    end

    private

    def role
      Admin::NormalizeRole.new(user_params[:role]).role
    end
  end
end
