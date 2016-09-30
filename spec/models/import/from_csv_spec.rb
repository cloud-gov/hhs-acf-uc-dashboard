require "rails_helper"

RSpec.describe Import::FromCSV, "#call" do
  let(:service) { Import::FromCSV.new(path) }
  let(:path) { File.expand_path(File.dirname(__FILE__) + "/../../../sample-daily-stats.csv") }

  context 'when there is already a record for that date' do
    let!(:capacity) {
      Capacity.create({
        date: Date.parse('2016-09-06'),
        funded: 1001,
        reserve: 101,
        activated: 202,
        unavailable: 333,
        status: 'unlocked'
      })
    }

    it 'updates the values that do not exist yet' do
      service.call
      capacity.reload
      expect(capacity.in_care).to eq(7124)
      expect(capacity.referrals).to eq(180)
      expect(capacity.discharges).to eq(256)
    end

    it 'will overwrite those value' do
      service.call
      capacity.reload
      expect(capacity.funded).to eq(8717)
      expect(capacity.reserve).to eq(2875)
      expect(capacity.activated).to eq(2000)
      expect(capacity.unavailable).to eq(396)
    end

    it 'locks the record' do
      service.call
      capacity.reload
      expect(capacity.status).to eq('locked')
    end
  end

  context 'when there is not a record for that date' do
    let(:capacity) { Capacity.where(reported_on: Date.parse('2016-09-06')).first }

    it 'imports creates records' do
      service.call
      expect(Capacity.count).to eq(49)
    end

    it 'record has the right imported values' do
      service.call
      expect(capacity.in_care).to eq(7124)
      expect(capacity.referrals).to eq(180)
      expect(capacity.discharges).to eq(256)
      expect(capacity.funded).to eq(8717)
      expect(capacity.reserve).to eq(2875)
      expect(capacity.activated).to eq(2000)
      expect(capacity.unavailable).to eq(396)
    end

    it 'locks the record' do
      service.call
      expect(capacity.status).to eq('locked')
    end
  end
end
