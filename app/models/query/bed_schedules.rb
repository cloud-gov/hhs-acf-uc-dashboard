module Query
  class BedSchedules
    def current
      @current ||= BedSchedule.where(current: true)
    end
  end
end
