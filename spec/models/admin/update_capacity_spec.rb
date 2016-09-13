require 'rails_helper'

RSpec.describe Admin::UpdateCapacity do
  let(:service) { Admin::UpdateCapacity.new('2016-09-06', params, current_user) }
  let(:current_user) { double(id: 123, email: 'adminy@hhs.gov') }
  let(:params) {
    {
      date: '2016-09-06',
      standard: 1001,
      reserve: 101,
      activated: 202,
      unavailable: 333,
      status: 'locked'
    }
  }

  let(:capacity_data) {
    double({
      valid?: true,
      validation_errors: [],
      normalized_status: params[:status],
      update_attributes: params
    })
  }

  before do
    allow_any_instance_of(Admin::LogCapacityChange).to receive(:call)
    allow(Admin::CapacityData).to receive(:new).and_return(capacity_data)
  end

  context 'when data is invalid' do
    let(:flash) { {} }

    let(:capacity_data) {
      double({
        valid?: false,
        validation_errors: [
          double(field: :standard, message: 'must be zero or greater'),
          double(field: :unavailable, message: 'must be zero or greater')
        ],
        normalized_status: 'unlocked',
        update_attributes: params
      })
    }

    it 'adds flash a error message' do
      service.save
      service.add_flash(flash)
      expect(flash[:error]).to include('problem')
    end

    it 'does not save the capacity record' do
      expect { service.save }.to_not change {
        Capacity.count
      }
    end

    it 'does not create a log' do
      expect { service.save }.to_not change {
        CapacityLog.count
      }
    end

    it 'adds errors to the capacity record' do
      service.save
      expect(service.capacity.errors).to_not be_empty
    end
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

    describe '#add_flash(flash_object)' do
      let(:flash) { {} }

      it 'adds a success message' do
        service.save
        service.add_flash(flash)
        expect(flash[:success]).to eq('Your changes have been saved.')
      end
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
  end
end
