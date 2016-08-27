class Role
  class None
    def manage_users?
      false
    end

    def name
      'No access'
    end

    def field_value
      nil
    end
  end
end
