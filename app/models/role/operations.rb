class Role
  class Operations < Base
    def name
      'Operations'
    end

    def field_value
      'operations'
    end

    def header_partial
      '/layouts/header_links/standard'
    end

    def report_access?
      true
    end
  end
end

