class CensusProjection
  attr_reader :seven_day_average_referral, :thirty_day_average_discharge,
    :growth, :collection
  attr_accessor :census

  def initialize(census, referrals, discharges, growth)
    @census = census
    @seven_day_average_referral = referrals
    @thirty_day_average_discharge = discharges
    @growth = growth
    @collection = []
  end

  def calculate
    (0..384).each do |n|
      self.census = calculate_next(census, n)
      collection << census
    end

    collection.map do |n|
      safe_round(n)
    end
  end

  def calculate_next(census, n)
    census_nd = census - (census * thirty_day_average_discharge)
    census_nd + seven_day_average_referral + growth * n
  end

  def safe_round(n)
    n.round
  rescue
    0
  end
end
