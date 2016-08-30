class Role
  class Operations
    def admin?
      false
    end

    def name
      'Operations'
    end

    def field_value
      'operations'
    end

    def home_path
      '/dashboards'
    end

    def dashboard_template(*)
      :operations
    end

    def header_partial
      '/layouts/header_links/standard'
    end
  end
end

