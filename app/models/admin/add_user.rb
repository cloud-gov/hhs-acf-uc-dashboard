module Admin
  class AddUser
    attr_reader :user_params

    def initialize(user_params)
      @user_params = user_params
    end

    def save
      model.skip_confirmation!
      model.save
      send_notification if saved?
      saved?
    end

    def saved?
      model.persisted?
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
      UserFormFlasher.new(flash_object, saved?, model.email).add
    end

    private

    def send_notification
      token = model.send(:set_reset_password_token)
      InvitationsMailer.change_password(model, token).deliver
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

    class UserFormFlasher < ::FormFlasher
      attr_reader :email

      def initialize(flash_object, saved, email)
        super(flash_object, saved)
        @email = email
      end

      def success_message
        "Successfully added #{email}."
      end
    end
  end
end
