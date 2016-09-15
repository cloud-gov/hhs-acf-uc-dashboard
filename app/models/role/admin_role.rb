class Role
  class AdminRole < Base
    def admin?
      true
    end

    def name
      'Admin'
    end

    def field_value
      'admin'
    end

    def home_path
      "/admin/capacities/current"
    end

    def header_partial
      '/layouts/header_links/admin'
    end

    def report_access?
      true
    end
  end
end

