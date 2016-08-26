class Role
  class AdminRole # Rails autoloading sucks the big one
    def manage_users?
      true
    end
  end
end

