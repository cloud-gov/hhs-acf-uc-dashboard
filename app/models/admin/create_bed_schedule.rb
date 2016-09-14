module Admin
  class CreateBedSchedule
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def call
      add_errors_if_not_valid
      create_bed_schedule_if_valid
    end

    def saved?
      bed_schedule.persisted?
    end

    def bed_schedule
      @bed_schedule ||= BedSchedule.new(new_attributes)
    end

    def add_flash(flash_object)
      FormFlasher.new(flash_object, saved?).add
    end

    private

    def data
      Attributes::BedScheduleData.new(params)
    end

    delegate :valid?, :validation_errors, :new_attributes,
      to: :data

    def add_errors_if_not_valid
      return if valid?
      validation_errors.each do |error|
        bed_schedule.errors.add(error.field, error.message)
      end
    end

    def create_bed_schedule_if_valid
      return false if !valid?
      bed_schedule.save
    end
  end
end
