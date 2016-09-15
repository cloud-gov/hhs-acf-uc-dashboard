module View
  class AdminShowCapacity
    attr_reader :capacity, :schedule_records, :new_bed_schedule_record

    def initialize(service)
      @capacity         = service.capacity
      @new_bed_schedule_record = service.new_bed_schedule
      @logs             = service.logs
      @schedule_records = service.scheduled_beds
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

    def schedules
      @schedules || schedule_records.map {|schedule| SchedulePresenter.new(schedule) }
    end

    def new_bed_schedule
      SchedulePresenter.new(new_bed_schedule_record)
    end

    def capacity_model_error
      View::ModelError.new(capacity, 'Some capacity values were invalid:')
    end

    def input_attributes
      return {} if capacity.status == 'unlocked'
      {readonly: true}
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

    class SchedulePresenter
      attr_reader :model

      def initialize(model)
        @model = model
      end

      delegate :facility_name, :bed_count, :persisted?,
        to: :model

      def month
        return model.month if model.month
        return unless model.scheduled_on
        model.scheduled_on.month
      end

      def day
        return model.day if model.day
        return unless model.scheduled_on
        model.scheduled_on.day
      end

      def year
        return model.year if model.year
        return unless model.scheduled_on
        model.scheduled_on.year
      end

      def id
        persisted? ? model.id : 'new'
      end

      def id_for_tag(name)
        "#{name}_#{id}"
      end

      def model_error
        View::ModelError.new(model, 'Some entries were invalid:')
      end
    end
  end
end
