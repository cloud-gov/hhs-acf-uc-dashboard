module Admin
  class UserCreate
    attr_reader :user_params

    def initialize(user_params)
      @user_params = user_params
    end

    def save
      @status = model.save
    end

    def model
      @model ||= User.new({
        email: user_params[:email],
        role: role,
        password: password,
        password_confirmation: password
      })
    end

    def role
      role_object.field_value
    end

    def role_object
      Role.all.detect{|role| role.name == role_name } || Role::None
    end

    def role_name
      user_params[:role]
    end

    def password
      return @password if @password
      chars = ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a.map(&:to_s)
      @password = ''
      8.times do
        @password += chars[rand(chars.size)]
      end
      @password
    end
  end
end
