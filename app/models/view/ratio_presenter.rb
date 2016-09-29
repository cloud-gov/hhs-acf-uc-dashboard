module View
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
end
