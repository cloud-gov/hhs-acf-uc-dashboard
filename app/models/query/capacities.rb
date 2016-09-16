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

    def locked_for_date(date)
      Capacity.where(reported_on: date, status: 'locked').take
    end

    def today
      @today ||= for_date(Date.today)
    end

    def first
      @first ||= Capacity.order(:reported_on).first
    end
  end
end
