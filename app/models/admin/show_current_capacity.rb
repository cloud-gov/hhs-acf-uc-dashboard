module Admin
  class ShowCurrentCapacity
    attr_reader :capacity, :logs, :scheduled_beds

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
      @scheduled_beds ||= bed_schedules_query.current
    end

    def capacities_query
      @capacities_query ||= Query::Capacities.new
    end

    def bed_schedules_query
      @bed_schedules_query ||= Query::BedSchedules.new
    end

    def new_capacity
      Capacity.new(last_capacity_default_values || default_values)
    end

    def last_capacity
      capacities_query.last
    end

    def last_capacity_default_values
      return if !last_capacity
      CapacityData::NewAttributes.from_attributes(last_capacity.attributes)
    end

    def default_values
      CapacityData::NewAttributes.from_scratch
    end
  end
end
