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
      '/reports'
    end

    def report_template(*)
      :'no-access'
    end

    def header_partial
      '/layouts/header_links/no_access'
    end
  end
end
