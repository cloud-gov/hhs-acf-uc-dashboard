module Query
  class Capacities
    def last
      @last ||= Capacity
        .where('capacity_on < ?', Date.today)
        .order('capacity_on DESC')
        .first
    end

    def for_date(date)
      Capacity.where(capacity_on: date).take
    end

    def today
      @today ||= for_date(Date.today)
    end
  end
end
