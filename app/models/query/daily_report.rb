module Query
  class DailyReport
    attr_reader :role, :params, :date, :capacity

    def initialize(role, params)
      @role = role
      @params = params
    end

    def type
      role.report_type(type)
    end

    def load_data
      load_capacity
    end

    def requested_date
      Date.parse(params[:id])
    rescue
      Date.today
    end

    def date
      capacity.date
    rescue
      requested_date
    end

    private

    def load_capacity
      @capacity = Query::Capacities.new.last_locked(requested_date)
    end
  end
end
