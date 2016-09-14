module Query
  class Capacities
    def last
      @last ||= Capacity
        .where('reported_on < ?', Date.today)
        .order('reported_on DESC')
        .first
    end

    def for_date(date)
      Capacity.where(reported_on: date).take
    end

    def today
      @today ||= for_date(Date.today)
    end
  end
end
