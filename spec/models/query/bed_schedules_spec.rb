require 'rails_helper'

RSpec.describe Query::BedSchedules do
  let(:query) { Query::BedSchedules.new }

  describe '#current' do
    context 'when there are records with the current flag true' do
      let!(:record) { BedSchedule.create!(facility_name: 'Homestead', current: true) }

      it 'should include that record' do
        expect(query.current).to include(record)
      end
    end

    context 'when there are no records with the current flag true' do
      let!(:record) { BedSchedule.create!(facility_name: 'Homestead', current: false) }

      it 'should include that record' do
        expect(query.current).to_not include(record)
      end
    end
  end
end

