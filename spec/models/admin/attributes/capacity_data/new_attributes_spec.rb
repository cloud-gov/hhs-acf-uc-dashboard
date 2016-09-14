require 'rails_helper'

RSpec.describe Admin::Attributes::CapacityData::NewAttributes do
  describe '.from_attributes' do
    let(:attributes) {
      Capacity.new({
        date: Date.parse('2016-09-13'),
        funded: 100,
        reserve: 101,
        activated: 17,
        unavailable: 333,
        status: 'locked'
      }).attributes
    }

    let(:converted) { Admin::Attributes::CapacityData::NewAttributes.from_attributes(attributes).symbolize_keys }

    it 'includes current date' do
      expect(converted[:date]).to eq(Date.today)
    end

    it 'sets the status to "unlocked"' do
      expect(converted[:status]).to eq('unlocked')
    end

    it 'gets values from attributes' do
      expect(converted[:funded]).to eq(100)
      expect(converted[:reserve]).to eq(101)
      expect(converted[:activated]).to eq(17)
      expect(converted[:unavailable]).to eq(333)
    end
  end
end
