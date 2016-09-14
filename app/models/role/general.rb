class Role
  class General
    def admin?
      false
    end

    def name
      'General'
    end

    def field_value
      'general'
    end

    def home_path
      '/reports'
    end

    def report_template(*)
      :general
    end

    def header_partial
      '/layouts/header_links/standard'
    end
  end
end
