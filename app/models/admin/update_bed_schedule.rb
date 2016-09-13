module Admin
  class UpdateBedSchedule
    attr_reader :params, :id

    def initialize(params, id)
      @id = id
      @params = params
    end

    def call
      bed_schedule.assign_attributes(update_attributes)
      add_errors_if_not_valid
      update_bed_schedule_if_valid
    end

    def bed_schedule
      @bed_schedule ||= BedSchedule.find(id)
    end

    def saved?
      @saved || false
    end

    def add_flash(flash_object)
      FormFlasher.new(flash_object, saved?).add
    end

    private

    def add_errors_if_not_valid
      return if valid?
      validation_errors.each do |error|
        bed_schedule.errors.add(error.field, error.message)
      end
    end

    def update_bed_schedule_if_valid
      return if !valid?
      bed_schedule.save
      @saved = true
    end

    delegate :valid?, :validation_errors, :update_attributes,
      to: :data

    def data
      BedScheduleData.new(params)
    end
  end
end
