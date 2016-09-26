module View
  class ShowDailyReport
    attr_reader :role, :date

    def initialize(querier)
      @role = querier.role
      @date = format_date(querier.date)
      @querier = querier
    end

    delegate :capacity, :params, :dates, :referrals, :in_care, :discharges, :api_error,
      to: :querier

    def report_content_partial
      if capacity && !api_error
        'content'
      elsif api_error
        'api_error'
      else
        'no_content'
      end
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

    def open_beds
      capacity.funded + capacity.activated - in_care
    end

    def reserve_beds
      capacity.reserve
    end

    private

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
