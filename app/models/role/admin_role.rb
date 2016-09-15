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

    def report_template(requested_template=nil)
      templates = ['general', 'no-access', 'operations']
      return requested_template if templates.include?(requested_template.to_s)
      :operations
    end

    def header_partial
      '/layouts/header_links/admin'
    end
  end
end

