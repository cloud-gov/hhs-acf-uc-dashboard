class Growth
  attr_reader :collection, :number_of_slopes

  def initialize(collection)
    @collection = collection
    @number_of_slopes = 7
  end

  def calculate
    return 0 if collection.empty?
    slopes.inject(0, &:+) / number_of_slopes.to_f
  end

  def slopes
    (0..(number_of_slopes - 1)).map do |n|
      values = collection[n..(n+30)]
      if values
        LinearRegression.new(values.map(&:referrals)).slope
      else
        0
      end
    end
  end
end
