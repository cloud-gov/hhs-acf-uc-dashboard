class LinearRegression
  attr_reader :x_values, :y_values, :length

  def initialize(y_values, x_values=nil)
    @y_values = y_values
    @length   = y_values.length
    @x_values = x_values || (0..(length-1)).to_a
  end

  def slope
    numerator / denominator
  end

  def numerator
    (0...length).reduce(0) do |sum, index|
      sum + ((x_values[index] - x_mean) * (y_values[index] - y_mean))
    end
  end

  def denominator
    x_values.reduce(0) do |sum, x|
      sum + ((x - x_mean) ** 2)
    end
  end

  def x_mean
    mean(x_values)
  end

  def y_mean
    mean(y_values)
  end

  def mean(values)
    values.inject(0, &:+) / values.length.to_f
  end
end

