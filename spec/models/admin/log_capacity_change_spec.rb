require 'rails_helper'

RSpec.describe Admin::LogCapacityChange do
  let(:service) {
    Admin::LogCapacityChange.new(capacity, current_user)
  }

  let(:capacity) {
    Capacity.create({
      status: 'unlocked',
      unavailable: 3,
      date: Date.today
    })
  }
  let(:log) { service.log }

  let(:current_user) { double(id: 123, email: 'admin@hhs.gov') }

  it 'creates a log record' do
    expect { service.call }.to change { capacity.logs.count}
    expect(log.user_id).to eq(123)
  end

  describe '#message' do
    context 'when the record is just created' do
      it 'does not include locked/unlocked' do
        service.call
        expect(log.message).to_not include('unlocked')
      end
    end

    context 'when changes to the values are made' do
      before do
        capacity.update_attributes(standard: 323)
        service.call
      end

      it 'creates the right message' do
        expect(log.message).to eq("admin@hhs.gov updated intake values")
      end
    end

    context 'when capacity is locked' do
      before do
        capacity.update_attributes(status: 'locked')
        service.call
      end

      it 'creates the right message' do
        expect(log.message).to eq("admin@hhs.gov locked intake values")
      end
    end

    context 'when capacity is unlocked' do
      let(:capacity) { Capacity.create(status: 'locked', date: Date.today) }

      before do
        capacity.update_attributes(status: 'unlocked')
        service.call
      end

      it 'creates the right message' do
        expect(log.message).to eq("admin@hhs.gov unlocked intake values")
      end
    end

    context 'when both status and values are changed' do
      before do
        capacity.update_attributes(status: 'locked', standard: 101)
        service.call
      end

      it 'creates the right message' do
        expect(log.message).to eq("admin@hhs.gov updated and locked intake values")
      end
    end
  end
end
