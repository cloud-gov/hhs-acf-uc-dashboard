module Admin
  class ShowCurrentCapacity
    attr_reader :capacity, :logs

    def load_models
      load_capacity
      load_capacity_logs
    end

    def load_capacity
      @capacity ||= existing_capacity || new_capacity
    end

    def load_capacity_logs
      @logs = capacity.logs.to_a
    end

    private

    def existing_capacity
      Capacity.where(capacity_on: Date.today).take
    end

    def new_capacity
      Capacity.new(last_capacity_default_values || default_values)
    end

    def last_capacity
      @last_capacity ||= Capacity.where('capacity_on < ?', Date.today).order('capacity_on DESC').first
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
