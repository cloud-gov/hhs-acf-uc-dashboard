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

    private

    class RatioPresenter
      attr_reader :number

      def initialize(number)
        @number = number
      end

      def percentage
        "#{percentile}%"
      end

      def alert_status
        if percentile <=65
          'notice'
        elsif percentile <= 85
          'warn'
        else
          'alert'
        end
      end

      private

      def percentile
        (number*100).round(0)
      end
    end

    def reserved_ratio
      data.in_care.to_f/(data.funded + data.reserve + data.activated)
    end

    def activation_ratio
      data.in_care.to_f/(data.funded + data.activated)
    end
  end
end
