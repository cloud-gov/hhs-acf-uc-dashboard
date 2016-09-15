module View
  class DateTimeFormatter
    attr_reader :date_time

    def initialize(date_time)
      @date_time = date_time
    end

    def us_date
      date_time.strftime('%m/%-d/%y')
    end

    def log_stamp
      date_time.strftime('%l:%M%P - %m/%-d/%y')
    end

    def full_month_us_date
      date_time.strftime('%B %-d, %Y')
    end

    def database_date
      date_time.strftime('%Y-%m-%d')
    end
  end
end
