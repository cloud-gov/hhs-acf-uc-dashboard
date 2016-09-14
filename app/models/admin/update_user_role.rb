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

    def add_flash(flash_object)
      flash_object[:success] = "Successfully changed role for #{user.email}."
    end

    private

    def role
      Attributes::NormalizeRole.new(user_params[:role]).role
    end
  end
end
