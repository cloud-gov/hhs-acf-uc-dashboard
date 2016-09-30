module View
  class AverageCalculations
    attr_reader :history

    def initialize(history)
      @history = history
    end

    def seven_day_discharge_average_per_hundred
      AveragePresenter.new(seven_day_discharge_ratio_average).average_per_hundred
    end

    def seven_day_discharge_average_per_hundred_status
      AveragePresenter.new(seven_day_discharge_ratio_average).alert_status
    end

    def thirty_day_discharge_average_per_hundred
      AveragePresenter.new(thirty_day_discharge_ratio_average).average_per_hundred
    end

    def thirty_day_discharge_average_per_hundred_status
      AveragePresenter.new(thirty_day_discharge_ratio_average).alert_status
    end

    def seven_day_discharge_ratio_average
      records = history_for(7).find_all {|record| record.discharges && record.in_care }
      average_discharge_ratios(records)
    end

    def thirty_day_discharge_ratio_average
      records = history_for(30).find_all {|record| record.discharges && record.in_care }
      average_discharge_ratios(records)
    end

    def seven_day_discharge_average
      discharge_average(history_for(7))
    end

    def week_vs_month_discharge_average_percentage
      percentile = (week_vs_month_discharge_average_ratio * 100).round
      "#{percentile}%"
    end

    private

    def history_for(n)
      history[0..(n-1)]
    end

    def discharge_average(records)
      records = records.find_all {|record| record.discharges }
      return 0 if records.empty?
      (records.map(&:discharges).inject(0, :+) / records.size.to_f).round
    end

    def average_discharge_ratios(records)
      discharges = records.map(&:discharges).inject(0, :+)
      in_care    = records.map(&:in_care).inject(0, :+)
      discharges.to_f / in_care.to_f
    end

    def week_vs_month_discharge_average_ratio
      return 0 if discharge_average(history_for(30)) == 0
      (discharge_average(history_for(7)) - discharge_average(history_for(30))).to_f / discharge_average(history_for(30))
    end
  end
end
