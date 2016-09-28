require 'rails_helper'

RSpec.describe CacheStats do
  let(:service) { CacheStats.new(capacity) }

  let(:capacity) {
    Capacity.create({
      reported_on: Date.today,
      funded: 2000,
      reserve: 1000,
      activated: 200,
      unavailable: 32,
      status: 'unlocked'
    })
  }

  let(:daily_statistics_response) {
    double('response', body: {
      discharges: 15,
      in_care: 4500,
      referrals: 32
    }.to_json)
  }

  describe '#call when the API is down' do
    before do
      allow(RestClient).to receive(:get).and_raise(ArgumentError)
    end

    it 'returns falsey' do
      expect(service.call).to eq(false)
    end

    it 'leaves the capacity as is' do
      service.call
      updated_at = capacity.updated_at
      expect(updated_at).to eq(capacity.reload.updated_at)
    end
  end

  describe '#call when the API is up' do
    before do
      allow(RestClient).to receive(:get).and_return(daily_statistics_response)
    end

    it 'returns something truthy' do
      expect(service.call).to eq(true)
    end

    it 'updates the capacity' do
      service.call
      capacity.reload
      expect(capacity.discharges).to eq(15)
      expect(capacity.in_care).to eq(4500)
      expect(capacity.referrals).to eq(32)
    end
  end

  describe '#call when the stats have already been cached' do
    before do
      allow(RestClient).to receive(:get).and_return(daily_statistics_response)
    end

    let(:capacity) {
      Capacity.create({
        reported_on: Date.today,
        funded: 2000,
        reserve: 1000,
        activated: 200,
        unavailable: 32,
        status: 'unlocked',
        discharges: 20,
        in_care: 4400,
        referrals: 20
      })
    }

    it 'returns something truthy' do
      expect(service.call).to eq(true)
    end

    it 'does not update the capacity' do
      service.call
      capacity.reload
      expect(capacity.discharges).to eq(20)
      expect(capacity.in_care).to eq(4400)
      expect(capacity.referrals).to eq(20)
    end
  end
end
