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

  describe '#last_thirty_days_from(date)' do
    let!(:records) {
      (-1..31).map do |n|
        Capacity.create(reported_on: date - n.days)
      end
    }

    let(:date) { Date.parse('2016-07-07') }


    it 'return 30 records' do
      expect(query.last_thirty_days_from(date).count).to eq(30)
    end

    it 'does not include the record for the day passed in' do
      todays_capacity = records.detect{|r| r.reported_on == date }
      expect(query.last_thirty_days_from(date)).to_not include(todays_capacity)
    end

    it 'starts and ends on the right days' do
      expect(query.last_thirty_days_from(date).first.reported_on).to eq(date - 1)
      expect(query.last_thirty_days_from(date).last.reported_on).to eq(date - 30)
    end

    it 'does not include dates out of bounds' do
      dates = query.last_thirty_days_from(date).map(&:reported_on)
      expect(dates).to_not include(date + 1)
      expect(dates).to_not include(date - 31)
    end
  end
end

