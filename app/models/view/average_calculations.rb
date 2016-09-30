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
      records = history[0..6].find_all {|record| record.discharges && record.in_care }
      average_discharges(records)
    end

    def thirty_day_discharge_average
      records = history[0..29].find_all {|record| record.discharges && record.in_care }
      average_discharges(records)
    end

    private

    def average_discharges(records)
      discharges = records.map(&:discharges).inject(0, :+)
      in_care    = records.map(&:in_care).inject(0, :+)
      discharges.to_f / in_care.to_f
    end
  end
end
