require 'rails_helper'

RSpec.describe LinearRegression do
  let(:calculator) { LinearRegression.new(y_values, x_values) }

  describe 'with two points' do
    let(:x_values) { [0, 2] }
    let(:y_values) { [0, 1] }

    it 'matches the slope exactly' do
      expect(calculator.slope).to eq(0.5)
    end
  end

  describe 'with three points' do
    let(:x_values) { [0, 1, 2] }
    let(:y_values) { [0, 1, 0.5] }

    it 'finds the best fit' do
      expect(calculator.slope).to eq(0.25)
    end
  end
end
