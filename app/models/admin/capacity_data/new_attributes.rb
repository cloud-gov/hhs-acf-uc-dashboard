module Admin
  class CapacityData
    class NewAttributes
      def from_scratch
        other_attributes.merge(values)
      end

      def from_attributes(attributes)
        attributes.slice(*CapacityData.value_fields.map(&:to_s)).merge(other_attributes)
      end

      def self.from_scratch
        new.from_scratch
      end

      def self.from_attributes(attributes)
        new.from_attributes(attributes)
      end

      private

      def values
        {
          standard: 0,
          reserve: 0,
          activated: 0,
          unavailable: 0,
        }
      end

      def other_attributes
        {
          date: Date.today,
          status: 'unlocked'
        }
      end
    end
  end
end
