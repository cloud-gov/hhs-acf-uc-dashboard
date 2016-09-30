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

    def last_thirty_days_from(date)
      Capacity
        .where("reported_on < ?", date)
        .where("reported_on >= ?", date - 30)
        .order("reported_on DESC")
        .to_a
    end

    def regressions_collection(date)
      Capacity
        .where("reported_on < ?", date)
        .where("reported_on >= ?", date - 37)
        .order("reported_on DESC")
        .to_a
    end

    def today
      @today ||= for_date(Date.today)
    end

    def first
      @first ||= Capacity.order(:reported_on).first
    end

    def all
      @all ||= Capacity.all.order(:reported_on).to_a
    end
  end
end
