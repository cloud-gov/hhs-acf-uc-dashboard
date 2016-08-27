class Role
  class AdminRole # Rails autoloading sucks the big one
    def manage_users?
      true
    end

    def name
      'Admin'
    end

    def field_value
      'admin'
    end
  end
end

