module View
  class ShowDailyReport
    attr_reader :role, :date

    def initialize(querier)
      @role = querier.role
      @date = format_date(querier.date)
      @capacity = querier.capacity
      @params = querier.params
    end

    def report_content_partial
      capacity ? 'content' : 'no_content' # also should depend on type ... someday soon
    end

    def type_name
      role.report_type(params[:type]).capitalize
    end

    private

    def format_date(raw_date)
      DateTimeFormatter.new(raw_date).full_month_us_date
    end

    attr_reader :capacity, :params
  end
end
