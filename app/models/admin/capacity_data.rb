module Admin
  class CapacityData
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def valid?
      integer_error_fields.empty?
    end

    def validation_errors
      integer_error_fields.map { |value_key|
        ValidationError.new(value_key, 'must be 0 or greater')
      }
    end

    def normalized_status
      return 'locked' if params[:status] == 'locked'
      'unlocked'
    end

    private

    class ValidationError < Struct.new(:field, :message)
    end

    def integer_error_fields
      integer_fields.select { |value_key|
        !is_positive_integer?(params[value_key].to_i)
      }
    end

    def integer_fields
      [:standard, :reserve, :activated, :unavailable]
    end

    def is_positive_integer?(value)
      value >= 0
    end
  end
end
