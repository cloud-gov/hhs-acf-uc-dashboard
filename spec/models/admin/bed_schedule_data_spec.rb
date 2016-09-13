require 'rails_helper'

RSpec.describe Admin::BedScheduleData do
  let(:data) { Admin::BedScheduleData.new(params) }

  describe 'when the date is invalid' do
    let(:params) {
      {
        month: '20',
        day: '40',
        year: '2016',
        facility_name: 'Homestead',
        bed_count: '100'
      }
    }

    it 'still provides attributes' do
      expect { data.base_attributes }.not_to raise_error
      expect(data.base_attributes[:scheduled_on]).to eq(nil)
    end

    it 'is invalid and has errors' do
      expect(data.valid?).to eq(false)
      expect(data.validation_errors.first.field).to eq(:scheduled_date)
    end
  end

  describe 'when the bed count is invalid' do
    let(:params) {
      {
        month: '10',
        day: '10',
        year: '2016',
        facility_name: 'Homestead',
        bed_count: '-100'
      }
    }

    it 'is invalid and has errors' do
      expect(data.valid?).to eq(false)
      expect(data.validation_errors.first.field).to eq(:bed_count)
    end
  end

  describe 'when all values are valid' do
    let(:params) {
      {
        month: '10',
        day: '10',
        year: '2016',
        facility_name: 'Homestead',
        bed_count: '100'
      }
    }

    it 'is valid and has no errors' do
      expect(data.valid?).to eq(true)
      expect(data.validation_errors).to be_empty
    end
  end
end
