require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
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

  describe "PUT #update" do
    let(:update_params) {
      {
        id: nobody.id,
        user: {role: 'Operations'}
      }
    }

    before do
      # devise test helpers not really working with Rails 5
      allow(controller).to receive(:authenticate_user!)
    end

    it 'redirects if not authorized' do
      allow(controller).to receive(:current_user).and_return(nobody)
      put :update, params: update_params
      expect(response).to redirect_to('/dashboards/default')
    end

    it 'updates the role of a user correctly when done by an admin' do
      allow(controller).to receive(:current_user).and_return(admin)
      put :update, params: update_params
      nobody.reload
      expect(nobody.role).to eq('operations')
    end

    it 'adds a flash message for success' do
      allow(controller).to receive(:current_user).and_return(admin)
      put :update, params: update_params
      expect(flash[:success]).to include(nobody.email)
    end
  end
end
