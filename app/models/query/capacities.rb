module Query
  class Capacities
    def last
      @last ||= Capacity
        .where('capacity_on < ?', Date.today)
        .order('capacity_on DESC')
        .first
    end

    def today
      @today ||= Capacity.where(capacity_on: Date.today).take
    end
  end
end
