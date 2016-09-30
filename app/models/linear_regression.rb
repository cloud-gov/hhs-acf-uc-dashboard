class LinearRegression
  attr_reader :x_values, :y_values, :length

  def initialize(x_values, y_values)
    @x_values = x_values
    @y_values = y_values
    @length = x_values.length
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

