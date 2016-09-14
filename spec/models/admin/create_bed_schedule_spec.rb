require 'rails_helper'

RSpec.describe Admin::CreateBedSchedule do
  let(:service) { Admin::CreateBedSchedule.new(params) }
  let(:bed_schedule) { service.bed_schedule }

  describe 'when params are full and valid' do
    let(:params) {
      {
        facility_name: 'Homestead',
        bed_count: '304',
        month: '10',
        day: '3',
        year: '2016'
      }
    }

    it 'creates a record with the right data' do
      service.call
      expect(bed_schedule).to be_persisted
      expect(bed_schedule.facility_name).to eq('Homestead')
      expect(bed_schedule.bed_count).to eq(304)
      expect(bed_schedule.scheduled_on).to eq(Date.parse('2016-10-3'))
      expect(bed_schedule.current).to be(true)
    end
  end

  describe 'when date has two digit year' do
    let(:params) {
      {
        facility_name: 'Homestead',
        bed_count: '304',
        month: '10',
        day: '3',
        year: '16'
      }
    }

    it 'assumes in the 2000s' do
      service.call
      expect(bed_schedule.scheduled_on).to eq(Date.parse('2016-10-3'))
    end
  end

  describe 'when the date is invalid' do
    let(:params) {
      {
        facility_name: 'Homestead',
        bed_count: '304',
        month: '33',
        day: '3',
        year: '16'
      }
    }

    it 'does not save' do
      expect { service.call }.to_not change { BedSchedule.count }
      expect(service.saved?).to be(false)
    end

    it 'records errors' do
      service.call
      expect(bed_schedule.errors[:scheduled_date]).to eq(['is not valid'])
    end
  end

  describe 'when the bed count is invalid' do
    let(:params) {
      {
        facility_name: 'Homestead',
        bed_count: '-304',
        month: '10',
        day: '3',
        year: '16'
      }
    }

    it 'does not save' do
      expect { service.call }.to_not change { BedSchedule.count }
      expect(service.saved?).to be(false)
    end

    it 'records errors' do
      service.call
      expect(bed_schedule.errors[:bed_count].first).to include('not valid')
    end
  end
end
