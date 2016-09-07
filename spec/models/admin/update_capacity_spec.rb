require 'rails_helper'

RSpec.describe Admin::UpdateCapacity do
  let(:service) { Admin::UpdateCapacity.new('2016-09-06', params, current_user) }
  let(:current_user) { double(id: 123, email: 'adminy@hhs.gov') }
  let(:params) {
    {
      standard: 1001,
      reserve: 101,
      activated: 202,
      unavailable: 333,
      status: 'locked'
    }
  }

  before do
    allow_any_instance_of(Admin::LogCapacityChange).to receive(:call)
    allow_any_instance_of(Admin::CapacityData).to receive(:valid?).and_return(true)
  end

  context 'when a capacity record with date exists' do
    let!(:capacity) { Capacity.create(date: '2016-09-06', status: 'unlocked') }

    it 'updates the existing record' do
      service.save
      capacity.reload
      expect(capacity.standard).to eq(params[:standard])
      expect(capacity.reserve).to eq(params[:reserve])
      expect(capacity.activated).to eq(params[:activated])
      expect(capacity.unavailable).to eq(params[:unavailable])
      expect(capacity.status).to eq('locked')
    end

    it 'creates a log' do
      expect_any_instance_of(Admin::LogCapacityChange).to receive(:call)
      service.save
    end

    it 'will not save or create a log when data is invalid' do
      expect_any_instance_of(Admin::CapacityData).to receive(:valid?).and_return(false)
      expect { service.save }.to_not change {
        CapacityLog.count
      }
      expect(capacity.reload.standard).to eq(nil)
    end
  end

  context 'when a capacity record does not exist with that date' do
    let(:capacity) { Capacity.where(capacity_on: '2016-09-06').take }

    it 'creates a new record' do
      service.save
      expect(capacity.date).to eq(Date.parse('2016-09-06'))
      expect(capacity.standard).to eq(params[:standard])
      expect(capacity.reserve).to eq(params[:reserve])
      expect(capacity.activated).to eq(params[:activated])
      expect(capacity.unavailable).to eq(params[:unavailable])
      expect(capacity.status).to eq('locked')
    end

    it 'creates a log' do
      expect_any_instance_of(Admin::LogCapacityChange).to receive(:call)
      service.save
    end

    it 'will not save or create a log when data is invalid' do
      expect_any_instance_of(Admin::CapacityData).to receive(:valid?).and_return(false)
      expect { service.save }.to_not change {
        CapacityLog.count + Capacity.count
      }
    end
  end
end
