class Role
  class None < Base
    def name
      'No access'
    end

    def field_value
      nil
    end

    def header_partial
      '/layouts/header_links/no_access'
    end
  end
end
