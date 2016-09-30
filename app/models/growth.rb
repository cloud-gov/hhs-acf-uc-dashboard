class Growth
  attr_reader :history, :number_of_slopes

  def initialize(history)
    @history = history
    @number_of_slopes = 7
  end

  def calculate
    slopes.inject(0, &:+) / number_of_slopes.to_f
  end

  def slopes
    (0..(number_of_slopes - 1)).map do |n|
      values = history[n..(n+30)].map(&:referrals)
      LinearRegression.new(values).slope
    end
  end
end
