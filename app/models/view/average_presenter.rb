module View
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
end
