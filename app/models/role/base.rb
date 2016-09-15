class Role
  class Base
    def admin?
      false
    end

    def home_path
      '/reports'
    end

    def report_template(*)
      :'no-access'
    end

    def report_access?
      report_template != :'no-access'
    end
  end
end

