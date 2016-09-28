module Admin
  class UpdateCapacity
    attr_reader :date, :capacity_params, :current_user, :cache_saved

    def initialize(date, capacity_params, current_user)
      @date = date
      @current_user = current_user
      @capacity_params = capacity_params
    end

    def save
      add_errors_if_not_valid
      save_capacity_if_valid
      save_log_if_capacity_saved
      cache_api_data_if_capacity_saved
    end

    def capacity
      return @capacity if @capacity
      @capacity =  Query::Capacities.new.for_date(date) || Capacity.new
      @capacity.assign_attributes(attributes)
      @capacity
    end

    def scheduled_beds
      @scheduled_beds ||= Query::BedSchedules.new.current
    end

    def saved?
      @saved
    end

    def logs
      capacity.logs
    end

    def add_flash(flash_object)
      FormFlasher.new(flash_object, saved?).add
      if !cache_saved
        flash_object[:error] ||= ""
        flash_object[:error] += " Unable to cache data from the API."
      end
    end

    private

    def data
      Attributes::CapacityData.new(capacity_params)
    end

    delegate :validation_errors, :valid?, :update_attributes,
      to: :data

    def add_errors_if_not_valid
      return if valid?
      validation_errors.each do |error|
        capacity.errors.add(error.field, error.message)
      end
    end

    def save_capacity_if_valid
      return if !valid?
      @saved = capacity.save
    end

    def save_log_if_capacity_saved
      return if !saved?
      Admin::CreateCapacityLog.new(capacity, current_user).call
    end

    def cache_api_data_if_capacity_saved
      return if !saved?
      @cache_saved = CacheStats.new(capacity).call
    end

    def attributes
      update_attributes(date)
    end
  end
end
