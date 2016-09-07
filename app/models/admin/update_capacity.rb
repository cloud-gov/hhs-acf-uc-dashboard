module Admin
  class UpdateCapacity
    attr_reader :date, :capacity_params, :current_user

    def initialize(date, capacity_params, current_user)
      @date = date
      @current_user = current_user
      @capacity_params = capacity_params
    end

    def save
      return if !valid?
      save_capacity
      save_log
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
      flash_object[:success] = 'Your changes have been saved.'
    end

    private

    def valid?
      CapacityData.new(capacity_params).valid?
    end

    def is_positive_integer?(value)
      value.is_a?(Fixnum) && value >= 0
    end

    def save_capacity
      @saved = capacity.save
    end

    def save_log
      Admin::LogCapacityChange.new(capacity, current_user).call if saved?
    end

    def attributes
      # TODO: add validation on these value
      {
        date:         date,
        standard:     capacity_params[:standard],
        reserve:      capacity_params[:reserve],
        activated:    capacity_params[:activated],
        unavailable:  capacity_params[:unavailable],
        status:       capacity_params[:status]
      }
    end
  end
end
