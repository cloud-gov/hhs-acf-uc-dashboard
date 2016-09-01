module View
  class AdminNewUser
    def initialize(user=nil)
      @model = user
    end

    def model
      @model ||= User.new
    end

    def role_names
      Role.all.map(&:name)
    end

    def role
      @model.role || default_role
    end

    def default_role
      'Operations'
    end

    def errors
      
    end
  end
end
