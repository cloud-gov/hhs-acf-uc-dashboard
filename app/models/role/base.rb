class Role
  class Base
    def admin?
      false
    end

    def home_path
      '/daily_reports/current'
    end

    def report_template(*)
      :'no-access'
    end

    def report_access?
      false
    end
  end
end

