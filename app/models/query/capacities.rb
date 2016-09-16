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

    def last_locked(date)
      Capacity
        .where('reported_on <= ?', date)
        .where(status: 'locked')
        .order('reported_on DESC')
        .first
    end

    def first
      @first ||= Capacity.order(:reported_on).first
    end
  end
end
