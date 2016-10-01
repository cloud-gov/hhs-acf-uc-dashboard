module View
  class ShowDailyReport
    attr_reader :role, :date, :data

    def initialize(querier)
      @role = querier.role
      @date = format_date(querier.date)
      @querier = querier
      @data = querier.capacity
    end

    delegate :capacity, :params, :dates,
      to: :querier

    delegate :referrals, :in_care, :discharges,
      to: :data

    delegate :open_beds,
      :activated_rate, :activated_rate_status,
      :reserved_rate, :reserved_rate_status,
      :funded_percentage, :funded_percentage_status,
      :funded_available_percentage, :funded_available_percentage_status,
      :current_funded_capacity, :total_reserve_capacity,
          to: :daily_calculations

    delegate :seven_day_discharge_average, :seven_day_discharge_average_per_hundred, :seven_day_discharge_average_per_hundred_status,
      :thirty_day_discharge_average_per_hundred, :thirty_day_discharge_average_per_hundred_status,
      :week_vs_month_discharge_average_percentage, :week_vs_month_referrals_average_percentage,
      :seven_day_referrals_average, :thirty_day_discharge_ratio_average,
          to: :average_calculations

    def report_content_partial
      if api_error?
        'api_error'
      elsif capacity
        'content'
      else
        'no_content'
      end
    end

    def operational_occupancy_partial
      if type_name == "Operations"
        "operational_occupancy"
      else
        "blank"
      end
    end

    def api_error?
      capacity && capacity.in_care.to_i == 0
    end

    def type_name
      role.report_type(params[:type]).capitalize
    end

    def available_dates
      dates_raw.map do |date|
        ReportDatePicker.new(date, querier.date)
      end
    end

    def types
      [
        OpenStruct.new(value: 'operations', name: 'Operations', selected: selected?('Operations')),
        OpenStruct.new(value: 'general', name: 'General', selected: selected?('General')),
      ]
    end

    def show_type_selector?
      role.name == "Admin"
    end

    def reserve_beds
      data.reserve
    end

    def funded_reserve_85_growth_0_capacity_status
      n = max_capacity(census_growth_0, total_reserve_capacity, 0.85)
      MaxCapacityPresenter.new(n).alert_status
    end

    def funded_reserve_85_growth_0_capacity
      n = max_capacity(census_growth_0, total_reserve_capacity, 0.85)
      MaxCapacityPresenter.new(n).days
    end

    def funded_reserve_85_growth_1_capacity_status
      n = max_capacity(census_growth_1, total_reserve_capacity, 0.85)
      MaxCapacityPresenter.new(n).alert_status
    end

    def funded_reserve_85_growth_1_capacity
      n = max_capacity(census_growth_1, total_reserve_capacity, 0.85)
      MaxCapacityPresenter.new(n).days
    end

    def funded_reserve_85_growth_2_capacity_status
      n = max_capacity(census_growth_2, total_reserve_capacity, 0.85)
      MaxCapacityPresenter.new(n).alert_status
    end

    def funded_reserve_85_growth_2_capacity
      n = max_capacity(census_growth_2, total_reserve_capacity, 0.85)
      MaxCapacityPresenter.new(n).days
    end

    def funded_reserve_95_growth_0_capacity_status
      n = max_capacity(census_growth_0, total_reserve_capacity, 0.95)
      MaxCapacityPresenter.new(n).alert_status
    end

    def funded_reserve_95_growth_0_capacity
      n = max_capacity(census_growth_0, total_reserve_capacity, 0.95)
      MaxCapacityPresenter.new(n).days
    end

    def funded_reserve_95_growth_1_capacity_status
      n = max_capacity(census_growth_1, total_reserve_capacity, 0.95)
      MaxCapacityPresenter.new(n).alert_status
    end

    def funded_reserve_95_growth_1_capacity
      n = max_capacity(census_growth_1, total_reserve_capacity, 0.95)
      MaxCapacityPresenter.new(n).days
    end

    def funded_reserve_95_growth_2_capacity_status
      n = max_capacity(census_growth_2, total_reserve_capacity, 0.95)
      MaxCapacityPresenter.new(n).alert_status
    end

    def funded_reserve_95_growth_2_capacity
      n = max_capacity(census_growth_2, total_reserve_capacity, 0.95)
      MaxCapacityPresenter.new(n).days
    end

    private

    def max_capacity(projection, total, limit)
      found_census = projection.detect do |census|
        census / total.to_f > limit
      end
      index = projection.find_index(found_census)
      index ? index + 1 : 366
    end

    def census_growth_0
      @funded_reserve_growth_0 ||= CensusProjection.new(
        data.in_care, seven_day_referrals_average, thirty_day_discharge_ratio_average, 0
      ).calculate
    end

    def census_growth_1
      @funded_reserve_growth_1 ||= CensusProjection.new(
        data.in_care, seven_day_referrals_average, thirty_day_discharge_ratio_average, growth
      ).calculate
    end

    def census_growth_2
      @funded_reserve_growth_2 ||= CensusProjection.new(
        data.in_care, seven_day_referrals_average, thirty_day_discharge_ratio_average, growth * 2
      ).calculate
    end

    def growth
      @growth ||= Growth.new(querier.regressions_collection).calculate
    end

    def daily_calculations
      @daily_calclations ||= DailyCalculations.new(data)
    end

    def average_calculations
      @average_calculations ||= AverageCalculations.new(querier.thirty_day_history)
    end

    def format_date(raw_date)
      DateTimeFormatter.new(raw_date).full_month_us_date
    end

    def selected?(type)
      type == type_name ? 'selected' : ''
    end

    def dates_raw
      querier.dates
    end

    attr_reader :querier
  end
end
