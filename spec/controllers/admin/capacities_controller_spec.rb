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
    it "requires authentication" do
      expect(controller).to receive(:authenticate_user!)
      get :index
    end

    it "redirects to dashboard authorization if current user is not an admin" do
      allow(controller).to receive(:authenticate_user!)
      allow(controller).to receive(:current_user).and_return(nobody)
      get :index
      expect(response).to redirect_to('/dashboards/default')
    end

    it "returns http success if current user is an admin" do
      allow(controller).to receive(:authenticate_user!)
      allow(controller).to receive(:current_user).and_return(admin)
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end

