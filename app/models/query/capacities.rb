module Query
  class Capacities
    def last
      @last ||= last_query(Date.today).first
    end

    def for_date(date)
      Capacity.where(reported_on: date).take
    end

    def today
      @today ||= for_date(Date.today)
    end

    def last_locked(date)
      last_query(date)
        .where(status: 'locked')
        .first
    end

    private

    def last_query(date)
      Capacity
        .where('reported_on <= ?', date)
        .order('reported_on DESC')
    end
  end
end
