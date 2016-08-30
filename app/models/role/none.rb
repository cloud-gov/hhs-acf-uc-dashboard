class Role
  class None
    def admin?
      false
    end

    def name
      'No access'
    end

    def field_value
      nil
    end

    def home_path
      "/dashboards"
    end

    def dashboard_template(*)
      :'no-access'
    end
  end
end
