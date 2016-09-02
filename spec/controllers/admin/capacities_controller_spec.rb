require 'rails_helper'

RSpec.describe Admin::CapacitiesController, type: :controller do
  let(:user_attributes) { {password: 'password', password_confirmation: 'password'} }

  let(:admin) {
    User.create!(user_attributes.merge({
      email: 'admin@hhs.gov',
      role: 'admin'
    }))
  }

  let(:nobody) {
    User.create!(user_attributes.merge({email: 'no-one@hhs.gov'}))
  }

  describe "GET #index" do
    it "requires authenticated user" do
      expect(controller).to receive(:authenticate_user!)
      expect(controller).to receive(:require!).with(:can_admin)
      get :index
    end
  end
end

