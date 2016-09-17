require "rails_helper"

RSpec.describe View::AdminCapacityIndex do
  let(:view_model) { View::AdminCapacityIndex.new(all) }
  let(:all) {
    [
      Capacity.new({
        reported_on: Date.today - 3.days,
        funded: 1000,
        reserve: 100,
        activated: 20,
        unavailable: 44,
        status: 'locked'
      }),
      Capacity.new({
        reported_on: Date.today,
        funded: 1010,
        reserve: 101,
        activated: 22,
        unavailable: 34,
        status: 'unlocked'
      })
    ]
  }

  let(:capacities) { view_model.capacities }

  describe '#capacities' do
    it 'orders by date descending' do
      expect(capacities[0].reported_on).to eq(Date.today)
      expect(capacities[1].reported_on).to eq(Date.today - 1)
      expect(capacities[2].reported_on).to eq(Date.today - 2)
      expect(capacities[3].reported_on).to eq(Date.today - 3)
    end

    it 'includes null records for dates not found in the capacity records' do
      null = capacities[1]
      expect(null.funded).to eq('-')
      expect(null.reserve).to eq('-')
      expect(null.activated).to eq('-')
      expect(null.unavailable).to eq('-')
      expect(null.status).to eq('No data')
    end

    it 'formats the dates' do
      expect(capacities.first.date).to eq(View::DateTimeFormatter.new(Date.today).us_date)
    end
  end
end
