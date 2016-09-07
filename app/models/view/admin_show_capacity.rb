module View
  class AdminShowCapacity
    attr_reader :capacity

    def initialize(service)
      @capacity = service.capacity
      @logs = service.logs
    end

    def status_set
      ['unlocked', 'locked']
    end

    def status
      capacity.status
    end

    def date
      capacity.date.strftime('%m/%d/%y')
    end

    def audit_logs
      @audit_logs ||= @logs.map{ |log| LogPresenter.new(log) }
    end

    def errors?
      !capacity.errors.empty?
    end

    def error_heading
      'Some capacity values were invalid:'
    end

    def error_messages
      capacity.errors.full_messages
    end

    class LogPresenter
      attr_reader :model

      def initialize(model)
        @model = model
      end

      delegate :message, to: :model

      def logged_on
        model.created_at.strftime('%l:%M%P - %m/%d/%y')
      end
    end
  end
end
