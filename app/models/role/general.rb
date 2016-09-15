class Role
  class General < Base
    def name
      'General'
    end

    def field_value
      'general'
    end

    def report_template(*)
      :general
    end

    def header_partial
      '/layouts/header_links/standard'
    end
  end
end
