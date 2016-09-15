require 'rails_helper'

RSpec.describe Query::Capacities do
  let(:query) { Query::Capacities.new }

  describe '#last' do
    context 'when there are multiple previous capacities' do
      let!(:much_earlier_capacity) {
        Capacity.create({
          date: Date.today - 2.days,
          funded: 8717,
          reserve: 2859,
          activated: 1607,
          unavailable: 421,
          status: 'locked'
        })
      }

      let!(:earlier_capacity) {
        Capacity.create({
          date: Date.today - 1.days,
          funded: 8715,
          reserve: 2860,
          activated: 1600,
          unavailable: 400,
          status: 'locked'
        })
      }

      it 'finds the most recent capacity that is not today' do
        expect(query.last).to eq(earlier_capacity)
      end
    end

    context 'when there is only one' do
      let!(:much_earlier_capacity) {
        Capacity.create({
          date: Date.today - 2.days,
          funded: 8717,
          reserve: 2859,
          activated: 1607,
          unavailable: 421,
          status: 'locked'
        })
      }

      it 'finds it' do
        expect(query.last).to eq(much_earlier_capacity)
      end
    end

    context 'when there are none' do
      it 'sadly return nil' do
        expect(query.last).to eq(nil)
      end
    end
  end

  describe '#today' do
    context 'when there are multiple including one for today' do
      let!(:earlier_capacity) {
        Capacity.create({
          date: Date.today - 1.days,
          funded: 8715,
          reserve: 2860,
          activated: 1600,
          unavailable: 400,
          status: 'locked'
        })
      }

      let!(:current_capacity) {
        Capacity.create({
          date: Date.today,
          funded: 8715,
          reserve: 2860,
          activated: 1600,
          unavailable: 400,
          status: 'locked'
        })
      }

      it 'returns the one for today' do
        expect(query.today).to eq(current_capacity)
      end
    end

    context 'when there are ones in the past, but not today' do
      let!(:earlier_capacity) {
        Capacity.create({
          date: Date.today - 1.days,
          funded: 8715,
          reserve: 2860,
          activated: 1600,
          unavailable: 400,
          status: 'locked'
        })
      }

      it 'returns nil :(' do
        expect(query.today).to eq(nil)
      end
    end
  end

  describe '#last_locked(date)' do
    let(:date) { Date.today - 4.days }

    context 'when no capacity exists' do
      it 'returns nil' do
        expect(query.last_locked(date)).to eq(nil)
      end
    end

    context 'when there is a capacity for the current date, but it is not locked, and there is not previous locked capacity' do
      let!(:future_capacity) { Capacity.create({reported_on: date + 3.days, status: 'locked'}) }
      let!(:daily_capacity) { Capacity.create({reported_on: date, status: 'unlocked'}) }

      it 'returns nil' do
        expect(query.last_locked(date)).to eq(nil)
      end
    end

    context 'when there is a capacity for current, but it is not locked an there is a previous locked capacity' do
      let!(:locked_capacity) { Capacity.create({reported_on: date - 3.days, status: 'locked'}) }
      let!(:future_capacity) { Capacity.create({reported_on: date + 3.days, status: 'locked'}) }
      let!(:daily_capacity) { Capacity.create({reported_on: date, status: 'unlocked'}) }

      it 'returns the last locked capacity' do
        expect(query.last_locked(date)).to eq(locked_capacity)
      end
    end

    context 'when there is a capacity for current that is locked' do
      let!(:daily_capacity) { Capacity.create({reported_on: date, status: 'locked'}) }

      it 'returns that capacity' do
        expect(query.last_locked(date)).to eq(daily_capacity)
      end
    end
  end

  describe '#available_dates' do
    let!(:current_capacity) {
      Capacity.create({
        date: Date.today,
        funded: 8715,
        reserve: 2860,
        activated: 1600,
        unavailable: 400,
        status: 'locked'
      })
    }

    let!(:earlier_capacity) {
      Capacity.create({
        date: Date.today - 1.days,
        funded: 8715,
        reserve: 2860,
        activated: 1600,
        unavailable: 400,
        status: 'locked'
      })
    }

    let!(:unlocked_capacity) {
      Capacity.create({
        date: Date.today - 3.days,
        funded: 8715,
        reserve: 2860,
        activated: 1600,
        unavailable: 400,
        status: 'unlocked'
      })
    }

    it 'finds only locked capacities' do
      expect(query.available_dates).to include(current_capacity, earlier_capacity)
      expect(query.available_dates).to_not include(unlocked_capacity)
    end

    it 'orders by reported_on' do
      expect(query.available_dates.first.id).to eq(earlier_capacity.id)
    end

    it 'only returns id and reported_on fields' do
      expect(query.available_dates.first.attributes.keys).to eq(['id', 'reported_on'])
    end
  end
end

