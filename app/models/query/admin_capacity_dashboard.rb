module Query
  class AdminCapacityDashboard
    attr_accessor :capacity, :logs, :scheduled_beds
    attr_writer :new_bed_schedule

    def load_models
      load_capacity
      load_capacity_logs
      load_scheduled_beds
      self
    end

    def new_bed_schedule
      @new_bed_schedule ||= BedSchedule.new
    end

    def replace_bed_schedule(schedule)
      @scheduled_beds = scheduled_beds.map do |item|
        item.id == schedule.id ? schedule : item
      end
    end

    private

    def load_capacity
      @capacity ||= capacities_query.today || new_capacity
    end

    def load_capacity_logs
      @logs ||= capacity.logs.to_a
    end

    def load_scheduled_beds
      @scheduled_beds ||= bed_schedules_query.current.to_a
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
      Admin::Attributes::CapacityData::NewAttributes.from_attributes(last_capacity.attributes)
    end

    def default_values
      Admin::Attributes::CapacityData::NewAttributes.from_scratch
    end
  end
end
