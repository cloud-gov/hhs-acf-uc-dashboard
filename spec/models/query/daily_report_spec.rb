require 'rails_helper'

RSpec.describe Query::DailyReport do
  let(:query) { Query::DailyReport.new(role, params) }
  let(:role) { Role::AdminRole.new }
  let(:params) { {id: 'current'} }

  let(:capacities_query) {
    double({
      locked_for_date: capacity,
      first: nil,
      last_thirty_days_from: [],
      regressions_collection: []
    })
  }

  let(:capacity) { nil }

  let(:daily_statistics_response) {
    double('response', body: {
      discharges: 15,
      in_care: 4500,
      referrals: 32
    }.to_json)
  }

  before do
    allow(RestClient).to receive(:get).and_return(daily_statistics_response)
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
      let(:capacity) {
        Capacity.new({
          reported_on: Date.today - 3.days,
          id: 42,
          funded: 3000,
          reserve: 1000,
          activated: 200,
          unavailable: 100
        })
      }

      it 'returns the capacity date' do
        query.load_data
        expect(query.date).to eq(capacity.reported_on)
      end
    end
  end

  describe '#dates' do
    let(:capacities_query) {
      double({
        first: Capacity.new(id: 123, reported_on: Date.today - 2.days),
        locked_for_date: Capacity.new(id: 234, reported_on: Date.today + 1),
        last_thirty_days_from: [],
        regressions_collection: []
      })
    }

    it 'puts the last locked record on the top, but otherwise orders by date' do
      query.load_data
      expect(query.dates.first).to eq(Date.today)
      expect(query.dates.last).to eq(Date.today - 2.days)
    end
  end

  describe 'daily statistics, when there is a capacity' do
    let(:capacity) {
      Capacity.new({
        funded: 3000,
        reserve: 1000,
        activated: 200,
        unavailable: 100
      })
    }

    it 'tries to cache the data' do
      expect_any_instance_of(CacheStats).to receive(:call)
      query.load_data
    end
  end
end

