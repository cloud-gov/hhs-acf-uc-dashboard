module View
  class ShowDailyReport
    attr_reader :role, :date

    def initialize(querier)
      @role = querier.role
      @date = format_date(querier.date)
      @capacity = querier.capacity
      @params = querier.params
      @available_dates_raw = querier.available_dates
    end

    def report_content_partial
      capacity ? 'content' : 'no_content' # also should depend on type ... someday soon
    end

    def type_name
      role.report_type(params[:type]).capitalize
    end

    def available_dates
      available_dates_raw.map do |date|
        DateTimeFormatter.new(date)
      end
    end

    private

    def format_date(raw_date)
      DateTimeFormatter.new(raw_date).full_month_us_date
    end

    attr_reader :capacity, :params, :available_dates_raw
  end
end
