module Admin
  class CreateCapacityLog
    attr_reader :capacity, :current_user, :log

    def initialize(capacity, current_user)
      @capacity = capacity
      @current_user = current_user
    end

    def call
      @log ||= capacity.logs.create(attributes)
    end

    private

    def attributes
      {
        user_id: current_user.id,
        message: message
      }
    end

    def message
      "#{current_user.email} #{actions.join(' and ')} intake values"
    end

    def actions
      action_set = []
      action_set << 'updated'       if values_updated?
      action_set << capacity.status if status_changed?
      action_set
    end

    def values_updated?
      !(previous_changes.keys & CapacityData.value_fields.map(&:to_s)).empty?
    end

    def status_changed?
      previous_changes.keys.include?('status') && capacity.created_at != capacity.updated_at
    end

    delegate :previous_changes, to: :capacity
  end
end
