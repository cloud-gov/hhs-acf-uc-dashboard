require 'rails_helper'

RSpec.describe Query::DailyReport do
  let(:query) { Query::DailyReport.new(role, params) }
  let(:role) { Role::AdminRole.new }
  let(:params) { {id: 'current'} }

  let(:capacities_query) {
    double({
      last_locked: capacity,
      first: nil
    })
  }

  let(:capacity) { nil }

  before do
    allow(Query::Capacities).to receive(:new).and_return(capacities_query)
  end

  describe '#requested_date' do
    context 'when "current"' do
      it 'uses today' do
        expect(query.requested_date).to eq(Date.today)
      end
    end

    context 'when invalid' do
      let(:params) { {id: 'wha?'} }

      it 'uses today' do
        expect(query.requested_date).to eq(Date.today)
      end
    end

    context 'when it is a parsable date' do
      let(:params) { {id: '2016-9-20'} }

      it 'uses that date' do
        expect(query.requested_date.month).to eq(9)
        expect(query.requested_date.day).to eq(20)
        expect(query.requested_date.year).to eq(2016)
      end
    end
  end

  describe '#date' do
    describe 'when there is no capacity' do
      it 'return the requested date' do
        query.load_data
        expect(query.date).to eq(query.requested_date)
      end
    end

    describe 'when there is a found capacity' do
      let(:capacity) { double(reported_on: Date.today - 3.days, id: 42) }

      it 'returns the capacity date' do
        query.load_data
        expect(query.date).to eq(capacity.reported_on)
      end
    end
  end

  describe '#dates' do
    let(:capacities_query) {
      double({
        first: double(id: 123, reported_on: Date.today - 2.days),
        last_locked: double(id: 234, reported_on: Date.today + 1)
      })
    }

    it 'puts the last locked record on the top, but otherwise orders by date' do
      query.load_data
      expect(query.dates.first).to eq(Date.today)
      expect(query.dates.last).to eq(Date.today - 2.days)
    end
  end
end

