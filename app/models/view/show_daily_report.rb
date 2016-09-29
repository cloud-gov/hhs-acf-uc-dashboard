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
      :current_funded_capacity, :total_reserve_capacity,
          to: :calculations

    def report_content_partial
      if api_error?
        'api_error'
      elsif capacity
        'content'
      else
        'no_content'
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
        DatePresenter.new(date, querier.date)
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

    private

    def calculations
      @calclations ||= DailyCalculations.new(data)
    end

    class DatePresenter
      attr_reader :formatter, :is_selected

      def initialize(date, selected_date)
        @is_selected = date == selected_date
        @formatter = DateTimeFormatter.new(date)
      end

      delegate :database_date, :full_month_us_date,
        to: :formatter

      def selected
        is_selected ? 'selected' : ''
      end
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
