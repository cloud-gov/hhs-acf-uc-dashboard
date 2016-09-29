module View
  class AverageCalculations
    attr_reader :history

    def initialize(history)
      @history = history
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

    def seven_day_discharge_average
      1
      # average discharge / average in-care
    end

    def thirty_day_discharge_average
      1
    end
  end
end
