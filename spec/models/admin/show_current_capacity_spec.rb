require 'rails_helper'

RSpec.describe Admin::ShowCurrentCapacity do
  let(:service) { Admin::ShowCurrentCapacity.new }

  context 'when there is already a current capacity for the day' do
    let!(:earlier_capacity) {
      Capacity.create({
        date: Date.today - 1.days,
        standard: 8715,
        reserve: 2860,
        activated: 1600,
        unavailable: 400,
        status: 'locked'
      })
    }

    let!(:current_capacity) {
      Capacity.create({
        date: Date.today,
        standard: 8718,
        reserve: 2866,
        activated: 1650,
        unavailable: 500,
        status: 'unlocked'
      })
    }

    describe '#capacity' do
      before do
        service.load_models
      end

      it 'returns the found capacity' do
        expect(service.capacity).to eq(current_capacity)
      end
    end
  end

  context 'when there is no current capacity, but there is a capacity for the previous day' do
    let!(:much_earlier_capacity) {
      Capacity.create({
        date: Date.today - 2.days,
        standard: 8717,
        reserve: 2859,
        activated: 1607,
        unavailable: 421,
        status: 'locked'
      })
    }

    let!(:earlier_capacity) {
      Capacity.create({
        date: Date.today - 1.days,
        standard: 8715,
        reserve: 2860,
        activated: 1600,
        unavailable: 400,
        status: 'locked'
      })
    }

    before do
      service.load_models
    end

    describe '#capacity' do
      let(:capacity) { service.capacity }

      it 'return a new record' do
        expect(capacity).to be_new_record
      end

      it 'default numeric values are based on last found record' do
        expect(capacity.standard).to eq(8715)
        expect(capacity.reserve).to eq(2860)
        expect(capacity.activated).to eq(1600)
        expect(capacity.unavailable).to eq(400)
      end

      it 'uses the current date (DC time)' do
        expect(capacity.date).to eq(Date.today)
      end

      it 'has the unlocked status' do
        expect(capacity.status).to eq('unlocked')
      end
    end
  end

  context 'when there is no current capacity, but there is a capacity days earlier' do
    let!(:earlier_capacity) {
      Capacity.create({
        date: Date.today - 2.days,
        standard: 8717,
        reserve: 2859,
        activated: 1607,
        unavailable: 421,
        status: 'locked'
      })
    }

    before do
      service.load_models
    end

    describe '#capacity' do
      let(:capacity) { service.capacity }

      it 'return a new record' do
        expect(capacity).to be_new_record
      end

      it 'default numeric values are based on last found record' do
        expect(capacity.standard).to eq(8717)
        expect(capacity.reserve).to eq(2859)
        expect(capacity.activated).to eq(1607)
        expect(capacity.unavailable).to eq(421)
      end

      it 'uses the current date (DC time)' do
        expect(capacity.date).to eq(Date.today)
      end

      it 'has the unlocked status' do
        expect(capacity.status).to eq('unlocked')
      end
    end
  end

  context 'when there are no capacities' do
    before do
      service.load_models
    end

    describe '#capacity' do
      let(:capacity) { service.capacity }

      it 'return a new record' do
        expect(capacity).to be_new_record
      end

      it 'has default numeric values of 0' do
        expect(capacity.standard).to eq(0)
        expect(capacity.reserve).to eq(0)
        expect(capacity.unavailable).to eq(0)
      end

      it 'uses the current date (DC time)' do
        expect(capacity.date).to eq(Date.today)
      end

      it 'has the unlocked status' do
        expect(capacity.status).to eq('unlocked')
      end
    end
  end
end
