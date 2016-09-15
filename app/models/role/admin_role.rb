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

    def report_type(type)
      possible_types = Role.all.map(&:field_value) - ['admin']
      normalized_type = possible_types.find {|possible_type| possible_type == type }
      normalized_type || 'operations'
    end
  end
end

