module Query
  class DailyReport
    attr_reader :role, :params, :date, :capacity, :dates,
      :daily_statistics, :api_error, :data

    def initialize(role, params)
      @role = role
      @params = params
    end

    def type
      role.report_type(type)
    end

    def load_data
      load_capacity
      load_dates
      if capacity
        load_api_statistics
        build_data_object
      end
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

    def referrals
      daily_statistics['referrals']
    end

    def in_care
      daily_statistics['in_care']
    end

    def discharges
      daily_statistics['discharges']
    end

    private

    def load_api_statistics
      @daily_statistics = ApiClient.new.daily_statistics
    rescue
      @api_error = true
      @daily_statistics = {}
    end

    def load_capacity
      @capacity = capacities_query.locked_for_date(requested_date)
    end

    def load_dates
      last = capacities_query.first || OpenStruct.new(reported_on: Date.today)
      @dates = ((last.reported_on)..Date.today).to_a.reverse
    end

    def capacities_query
      @capacities_query = Query::Capacities.new
    end

    def build_data_object
      @data = OpenStruct.new({
        funded: capacity.funded,
        reserve: capacity.reserve,
        activated: capacity.activated,
        unavailable: capacity.unavailable,
        referrals: daily_statistics['referrals'],
        in_care: daily_statistics['in_care'],
        discharges: daily_statistics['discharges']
      })
    end
  end
end
