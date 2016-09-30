module View
  class ReportDatePicker
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
end
