class Growth
  attr_reader :collection, :number_of_slopes

  def initialize(collection)
    @collection = collection
    @number_of_slopes = 7
  end

  def calculate
    slopes.inject(0, &:+) / number_of_slopes.to_f
  end

  def slopes
    (0..(number_of_slopes - 1)).map do |n|
      values = collection[n..(n+30)].map(&:referrals)
      LinearRegression.new(values).slope
    end
  end
end
