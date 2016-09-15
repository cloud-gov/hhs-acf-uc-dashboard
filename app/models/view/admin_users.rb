module View
  class AdminUsers
    attr_reader :user_models

    def initialize(user_models)
      @user_models = user_models
    end

    def users
      @users ||= user_models.map do |model|
        UserPresentation.new(model)
      end
    end

    def role_names
      Role.all.map(&:name)
    end

    class UserPresentation
      attr_reader :user

      def initialize(user)
        @user = user
      end

      delegate :email, :id,
        to: :user

      def role
        Role.new(user).name
      end

      def confirmed_at
        return 'pending' if !user.confirmed_at
        DateTimeFormatter.new(user.confirmed_at).us_date
      end
    end
  end
end
