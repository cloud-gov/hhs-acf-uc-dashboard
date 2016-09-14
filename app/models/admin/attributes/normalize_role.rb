module Admin
  module Attributes
    class NormalizeRole
      attr_reader :role_name

      def initialize(role_name)
        @role_name = role_name
      end

      def role
        role_object.field_value
      end

      def role_object
        Role.all.detect{|role| role.name == role_name } || Role::None
      end
    end
  end
end
