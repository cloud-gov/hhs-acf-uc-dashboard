require 'rails_helper'

RSpec.describe Admin::AddUser do
  let(:service) { Admin::AddUser.new(params) }

  before(:each) do
    ActionMailer::Base.deliveries.clear
  end

  describe 'success' do
    let(:params) {
      {
        email: 'foo@hhs.gov',
        role: 'Operations'
      }
    }

    before do
      service.save
    end

    it 'sets up user to not require confirmation' do
      expect(service.model.confirmed_at).to_not be_nil
    end

    it 'adds a fake password to the user' do
      expect(service.model.password.length).to eq(8)
      expect(service.model.encrypted_password).not_to be(nil)
    end

    it 'saves the model' do
      expect(service.model).to be_persisted
    end

    it 'sends a notification' do
      expect(ActionMailer::Base.deliveries.first.subject).to include('invited')
    end
  end

  describe 'with bad params' do
    let(:params) {
      {
        email: 'not-an-email-yo!',
        role: 'Operations'
      }
    }

    before do
      service.save
    end

    it 'does not send the notification' do
      expect(ActionMailer::Base.deliveries.size).to eq(0)
    end
  end
end
