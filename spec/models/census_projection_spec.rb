require 'rails_helper'

RSpec.describe CensusProjection do
  let(:projection) { CensusProjection.new(in_care, seven_day_referrals, thirty_day_average_discharge, growth) }

  let(:in_care) { 8059 }
  let(:seven_day_referrals) { 176 }
  let(:thirty_day_average_discharge) { 0.01962682246 }

  let(:collection) { projection.calculate }

  describe 'when growth is 0' do
    let(:growth) { 0 }

    it 'calculates selected values correctly' do
      expect(collection[0]).to eq(8077)
      expect(collection[1]).to eq(8094)
    end
  end

  describe 'when growth is negative' do
    let(:growth) { -0.24648617511520737 }

    it 'calculates reasonably' do
      expect(collection[0]).to be > 0
      expect(collection[1]).to be > 0
      expect(collection[2]).to be > 0
    end
  end
end
