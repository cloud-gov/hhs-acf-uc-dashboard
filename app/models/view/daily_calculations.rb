module View
  class DailyCalculations
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def open_beds
      data.funded + data.activated - data.in_care
    end

    def current_funded_capacity
      data.funded + data.activated
    end

    def total_reserve_capacity
      current_funded_capacity + data.reserve
    end

    def activated_rate
      RatioPresenter.new(activation_ratio).percentage
    end

    def activated_rate_status
      RatioPresenter.new(activation_ratio).alert_status
    end

    def reserved_rate
      RatioPresenter.new(reserved_ratio).percentage
    end

    def reserved_rate_status
      RatioPresenter.new(reserved_ratio).alert_status
    end

    def seven_day_discharge_average_per_hundred
      AveragePresenter.new(seven_day_discharge_average).average_per_hundred
    end

    def seven_day_discharge_average_per_hundred_status
      AveragePresenter.new(seven_day_discharge_average).alert_status
    end

    def thirty_day_discharge_average_per_hundred
      AveragePresenter.new(thirty_day_discharge_average).average_per_hundred
    end

    def thirty_day_discharge_average_per_hundred_status
      AveragePresenter.new(thirty_day_discharge_average).alert_status
    end

    private

    class AveragePresenter
      attr_reader :number

      def initialize(number)
        @number = number
      end

      def average_per_hundred
        (number/100.0).round(1)
      end

      def alert_status
        if average_per_hundred <= 2
          'alert'
        elsif average_per_hundred <= 2.4
          'warn'
        else
          'alert'
        end
      end
    end

    def reserved_ratio
      data.in_care.to_f/(data.funded + data.reserve + data.activated)
    end

    def activation_ratio
      data.in_care.to_f/(data.funded + data.activated)
    end

    def seven_day_discharge_average
      1
      # average discharge / average in-care
    end

    def thirty_day_discharge_average
      1
    end
  end
end
