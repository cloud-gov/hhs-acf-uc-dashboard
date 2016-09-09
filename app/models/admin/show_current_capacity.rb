module Admin
  class ShowCurrentCapacity
    attr_reader :capacity, :logs

    def load_models
      load_capacity
      load_capacity_logs
      load_scheduled_beds
    end

    private

    def load_capacity
      @capacity ||= capacities_query.today || new_capacity
    end

    def load_capacity_logs
      @logs ||= capacity.logs.to_a
    end

    def load_scheduled_beds
      @scheduled_beds ||= BedSchedule.where(current: true)
    end

    def capacities_query
      @capacities_query ||= Query::Capacities.new
    end

    def new_capacity
      Capacity.new(last_capacity_default_values || default_values)
    end

    def last_capacity
      capacities_query.last
    end

    def last_capacity_default_values
      return if !last_capacity
      new_record_defaults.merge({
        standard: last_capacity.standard,
        reserve: last_capacity.reserve,
        activated: last_capacity.activated,
        unavailable: last_capacity.unavailable
      })
    end

    def new_record_defaults
      {
        date: Date.today,
        status: 'unlocked'
      }
    end

    def default_values
      new_record_defaults.merge({
        standard: 0,
        reserve: 0,
        activated: 0,
        unavailable: 0,
      })
    end
  end
end
