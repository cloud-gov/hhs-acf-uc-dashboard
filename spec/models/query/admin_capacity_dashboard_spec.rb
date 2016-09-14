require 'rails_helper'

RSpec.describe Query::AdminCapacityDashboard do
  let(:service) { Query::AdminCapacityDashboard.new }

  before do
    allow(Query::Capacities).to receive(:new).and_return(capacities_query)
  end

  context 'when there is already a current capacity for the day' do
    let(:capacities_query) {
      double({
        today: Capacity.new({
          date: Date.today,
          standard: 8718,
          reserve: 2866,
          activated: 1650,
          unavailable: 500,
          status: 'unlocked'
        }),
        last: Capacity.new({
          date: Date.today - 1.days,
          standard: 8715,
          reserve: 2860,
          activated: 1600,
          unavailable: 400,
          status: 'locked'
        })
      })
    }

    describe '#capacity' do
      before do
        service.load_models
      end

      it 'returns the found capacity' do
        expect(service.capacity).to eq(capacities_query.today)
      end
    end
  end

  context 'when there is no current capacity, but there is an earlier capacity' do
    let(:capacities_query) {
      double({
        today: nil,
        last: Capacity.new({
          date: Date.today - 1.days,
          standard: 8715,
          reserve: 2860,
          activated: 1600,
          unavailable: 400,
          status: 'locked'
        })
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

  context 'when there are no capacities' do
    let(:capacities_query) {
      double({
        today: nil,
        last: nil
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

  describe '#replace_bed_schedule' do
    let(:capacities_query) {
      double({
        today: nil,
        last: nil
      })
    }

    let!(:saved_bed_schedule) {
      BedSchedule.create({
        facility_name: 'Homestead',
        scheduled_on: Date.parse('2016-10-03'),
        bed_count: 200,
        current: true
      })
    }

    let(:edited_bed_schedule) {
      schedule = BedSchedule.find(saved_bed_schedule.id)
      schedule.bed_count = -300
      schedule
    }

    it 'substitutes by id' do
      service.load_models
      service.replace_bed_schedule(edited_bed_schedule)
      expect(service.scheduled_beds.first).to equal(edited_bed_schedule)
      expect(service.scheduled_beds.first.bed_count).to equal(-300)
    end
  end
end
