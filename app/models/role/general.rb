class Role
  class General < Base
    def name
      'General'
    end

    def field_value
      'general'
    end

    def header_partial
      '/layouts/header_links/standard'
    end

    def report_access?
      true
    end
  end
end
