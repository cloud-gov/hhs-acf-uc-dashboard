module Admin
  class BedScheduleData
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def valid?
      date_valid? && bed_count_valid?
    end

    def validation_errors
      date_errors + bed_count_errors
    end

    def bed_count
      params[:bed_count].to_i
    end

    def scheduled_on
      parse_date
    rescue ArgumentError
      nil
    end

    def new_attributes
      {
        facility_name: params[:facility_name],
        bed_count: bed_count,
        scheduled_on: scheduled_on,
        current: true
      }
    end

    private

    def bed_count_valid?
      bed_count >= 0
    end

    def date_valid?
      true if parse_date
    rescue ArgumentError
      false
    end

    def parse_date
      Date.parse("#{params[:year]}-#{params[:month]}-#{params[:day]}")
    end

    def date_errors
      return [] if date_valid?
      [ValidationError.new(:scheduled_date, 'is not valid')]
    end

    def bed_count_errors
      return [] if bed_count_valid?
      [ValidationError.new(:bed_count, 'must be 0 or greater')]
    end
  end
end
