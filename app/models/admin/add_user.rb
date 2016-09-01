module Admin
  class AddUser
    attr_reader :user_params

    def initialize(user_params)
      @user_params = user_params
    end

    def save
      @saved = model.save
    end

    def saved?
      @saved
    end

    def model
      @model ||= User.new({
        email: user_params[:email],
        role: role,
        password: password,
        password_confirmation: password
      })
    end

    def add_flash(flash_object)
      flash_object[flash_key] = flash_message
    end

    private

    def flash_key
      saved? ? :success : :error
    end

    def flash_message
      saved? ? flash_success_message : flash_error_message
    end

    def flash_success_message
      "Successfully added #{model.email}."
    end

    def flash_error_message
      "There was a problem saving this user."
    end

    def role
      Admin::NormalizeRole.new(user_params[:role]).role
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
