module View
  class ShowDailyReport
    attr_reader :role, :date

    def initialize(querier)
      @role = querier.role
      @date = format_date(querier.date)
      @capacity = querier.capacity
      @params = querier.params
      @dates_raw = querier.dates
      @querier = querier
    end

    def report_content_partial
      capacity ? 'content' : 'no_content'
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

    attr_reader :capacity, :params, :dates_raw, :querier
  end
end
