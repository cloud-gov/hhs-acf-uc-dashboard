require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  describe "GET #index" do
    let(:user_attributes) { {password: 'password', password_confirmation: 'password'} }

    let(:admin) {
      user = User.new(user_attributes.merge({email: 'admin@hhs.gov'}))
      user.role = 'admin'
      user.save!
      user
    }

    let(:nobody) {
      User.create!(user_attributes.merge({email: 'admin@hhs.gov'}))
    }

    it "requires authentication" do
      expect(controller).to receive(:authenticate_user!)
      get :index
    end

    it "redirects to dashboard authorization if current user is not an admin" do
      allow(controller).to receive(:authenticate_user!)
      allow(controller).to receive(:current_user).and_return(nobody)
      get :index
      expect(response).to redirect_to('/dashboard_authorization')
    end

    it "returns http success if current user is an admin" do
      allow(controller).to receive(:authenticate_user!)
      allow(controller).to receive(:current_user).and_return(admin)
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end
