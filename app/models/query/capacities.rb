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

    def available_dates
      @available_dates ||= Capacity
        .where(status: 'locked')
        .select(:id, :reported_on)
        .order(:reported_on)
        .to_a
    end
  end
end
