module View
  class MaxCapacityPresenter
    attr_reader :number

    def initialize(number)
      @number = number
    end

    def days
      number > 365 ? "365+" : number
    end

    def alert_status
      if number < 30
        'alert'
      elsif number <= 60
        'warn'
      else
        'notice'
      end
    end
  end
end

