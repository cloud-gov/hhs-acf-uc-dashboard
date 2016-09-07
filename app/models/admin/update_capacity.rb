module Admin
  class UpdateCapacity
    attr_reader :date, :capacity_params, :current_user

    def initialize(date, capacity_params, current_user)
      @date = date
      @current_user = current_user
      @capacity_params = capacity_params
    end

    def save
      add_errors_if_not_valid
      save_capacity_if_valid
      save_log_if_capacity_saved
    end

    def capacity
      return @capacity if @capacity
      @capacity = Capacity.where(capacity_on: date).take || Capacity.new
      @capacity.assign_attributes(attributes)
      @capacity
    end

    def saved?
      @saved
    end

    def logs
      capacity.logs
    end

    def add_flash(flash_object)
      if saved?
        flash_object[:success] = 'Your changes have been saved.'
      else
        flash_object[:error] = 'There was a problem saving these values.'
      end
    end

    private

    def add_errors_if_not_valid
      return if valid?
      CapacityData.new(capacity_params).validation_errors.each do |error|
        capacity.errors.add(error.field, error.message)
      end
    end

    def save_capacity_if_valid
      return if !valid?
      @saved = capacity.save
    end

    def save_log_if_capacity_saved
      return if !saved?
      Admin::LogCapacityChange.new(capacity, current_user).call
    end

    def valid?
      CapacityData.new(capacity_params).valid?
    end

    def is_positive_integer?(value)
      value.is_a?(Fixnum) && value >= 0
    end

    def attributes
      # TODO: normalize status
      {
        date:         date,
        standard:     capacity_params[:standard],
        reserve:      capacity_params[:reserve],
        activated:    capacity_params[:activated],
        unavailable:  capacity_params[:unavailable],
        status:       CapacityData.new(capacity_params).normalized_status
      }
    end
  end
end
