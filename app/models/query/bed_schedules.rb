module Query
  class BedSchedules
    def current
      @current ||= BedSchedule.where(current: true).to_a
    end
  end
end
