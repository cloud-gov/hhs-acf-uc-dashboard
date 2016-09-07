class Role
  class AdminRole # Rails autoloading sucks the big one
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

    def dashboard_template(requested_template)
      templates = ['general', 'no-access', 'operations']
      return requested_template if templates.include?(requested_template.to_s)
      :operations
    end

    def header_partial
      '/layouts/header_links/admin'
    end
  end
end

