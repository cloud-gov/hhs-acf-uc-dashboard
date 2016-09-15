module Query
  class DailyReport
    attr_reader :role, :params, :date, :capacity, :available_dates

    def initialize(role, params)
      @role = role
      @params = params
    end

    def type
      role.report_type(type)
    end

    def load_data
      load_capacity
      load_available_dates
    end

    def requested_date
      Date.parse(params[:id])
    rescue
      Date.today
    end

    def date
      capacity.reported_on
    rescue
      requested_date
    end

    private

    def load_capacity
      @capacity = capacities_query.last_locked(requested_date)
    end

    def load_available_dates
      date_models = capacities_query.available_dates.select do |date_model|
        date_model.id != (capacity || OpenStruct.new(id: nil)).id
      end
      date_models.unshift(capacity) if capacity
      @available_dates = date_models.map(&:reported_on)
    end

    def capacities_query
      @capacities_query = Query::Capacities.new
    end
  end
end
