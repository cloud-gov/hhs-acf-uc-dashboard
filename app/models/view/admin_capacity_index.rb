module View
  class AdminCapacityIndex
    def initialize(capacities)
      @capacities_records = capacities
    end

    def capacities
      capacities_with_nulls.map {|record| CapacityPresenter.new(record) }
    end

    private

    def capacities_with_nulls
      dates.map do |date|
        capacities_records.detect {|record| record.reported_on == date } || NullCapacity.new(date)
      end
    end

    def dates
      (capacities_records.first.reported_on..Date.today).to_a.reverse
    end

    class NullCapacity
      attr_reader :reported_on

      def initialize(date)
        @reported_on = date
      end

      [:funded, :reserve, :activated, :unavailable].each do |meth|
        define_method(meth) do
          '-'
        end
      end

      def status
        'No data'
      end
    end

    class CapacityPresenter
      attr_reader :model

      def initialize(model)
        @model = model
      end

      delegate :reported_on, :funded, :reserve, :activated, :unavailable, :status,
        to: :model

      def date
        DateTimeFormatter.new(reported_on).us_date
      end
    end

    attr_reader :capacities_records
  end
end
