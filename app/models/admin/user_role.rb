module Admin
  class UserRole
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
      role_object.field_value
    end

    def role_object
      Role.all.detect{|role| role.name == role_name } || Role::None
    end

    def role_name
      user_params[:role]
    end
  end
end
