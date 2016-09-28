require 'rails_helper'

RSpec.describe Admin::UpdateCapacity do
  let(:service) { Admin::UpdateCapacity.new('2016-09-06', params, current_user) }
  let(:current_user) { double(id: 123, email: 'adminy@hhs.gov') }
  let(:params) {
    {
      date: '2016-09-06',
      funded: 1001,
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
    allow_any_instance_of(Admin::CreateCapacityLog).to receive(:call)
    allow_any_instance_of(CacheStats).to receive(:call).and_return(true)
    allow(Admin::Attributes::CapacityData).to receive(:new).and_return(capacity_data)
  end

  context 'when data is invalid' do
    let(:flash) { {} }

    let(:capacity_data) {
      double({
        valid?: false,
        validation_errors: [
          double(field: :funded, message: 'must be zero or greater'),
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
      expect_any_instance_of(Admin::CreateCapacityLog).to_not receive(:call)
      service.save
    end

    it 'does not try to cache data' do
      expect_any_instance_of(CacheStats).to_not receive(:call)
      service.save
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
      expect(capacity.funded).to eq(params[:funded])
      expect(capacity.reserve).to eq(params[:reserve])
      expect(capacity.activated).to eq(params[:activated])
      expect(capacity.unavailable).to eq(params[:unavailable])
      expect(capacity.status).to eq('locked')
    end

    it 'creates a log' do
      expect_any_instance_of(Admin::CreateCapacityLog).to receive(:call)
      service.save
    end

    it 'tries to cache api data' do
      expect_any_instance_of(CacheStats).to receive(:call)
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

    describe '#add_flash(flash_object) when the API fails' do
      let(:flash) { {} }

      it 'adds a success message' do
        allow_any_instance_of(CacheStats).to receive(:call).and_return(false)
        service.save
        service.add_flash(flash)
        expect(flash[:success]).to eq('Your changes have been saved.')
        expect(flash[:error]).to include('Unable to cache data from the API.')
      end
    end
  end

  context 'when a capacity record does not exist with that date' do
    let(:capacity) { Capacity.where(reported_on: '2016-09-06').take }

    it 'creates a new record' do
      service.save
      expect(capacity.date).to eq(Date.parse('2016-09-06'))
      expect(capacity.funded).to eq(params[:funded])
      expect(capacity.reserve).to eq(params[:reserve])
      expect(capacity.activated).to eq(params[:activated])
      expect(capacity.unavailable).to eq(params[:unavailable])
      expect(capacity.status).to eq('locked')
    end

    it 'creates a log' do
      expect_any_instance_of(Admin::CreateCapacityLog).to receive(:call)
      service.save
    end
  end
end
