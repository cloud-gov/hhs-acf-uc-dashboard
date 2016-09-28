class CacheStats
  attr_reader :capacity, :daily_statistics, :api_error

  def initialize(capacity)
    @capacity = capacity
  end

  def call
    return true if already_cached?
    get_stats
    return false if api_error
    update_capacity
  end

  def get_stats
    @daily_statistics = ApiClient.new.daily_statistics(capacity.date)
  rescue
    @api_error = true
    @daily_statistics = {}
  end

  def update_capacity
    capacity.update_attributes(attributes)
  end

  def attributes
    {
      referrals: daily_statistics['referrals'],
      in_care: daily_statistics['in_care'],
      discharges: daily_statistics['discharges']
    }
  end

  def already_cached?
    capacity.in_care.to_i > 0
  end
end
