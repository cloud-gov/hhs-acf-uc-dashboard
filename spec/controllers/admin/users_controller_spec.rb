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

  describe 'POST #create' do
    before do
      allow(controller).to receive(:authenticate_user!)
      allow(controller).to receive(:require!)
    end

    context 'when the params are good' do
       let(:create_params) {
        {
          user: {
            email: 'foo@hhs.gov',
            role: 'Admin'
          }
        }
      }

      it 'requires an admin to be the current user' do
        expect(controller).to receive(:authenticate_user!)
        expect(controller).to receive(:require!).with(:can_admin)
        post :create, params: create_params
      end

      it "saves the user with the right data" do
        post :create, params: create_params
        user = User.where(email: create_params[:user][:email]).first
        expect(user.role).to eq('admin')
      end

      it "sends an email"

      it "generates a flash success message" do
        post :create, params: create_params
        expect(flash[:success]).to include(create_params[:user][:email])
      end

      it "redirects to index" do
        post :create, params: create_params
        expect(response).to redirect_to('/admin/users')
      end
    end

    context 'when params are incorrect to save the user' do
      let(:create_params) { { user: {role: 'Admin'} } }

      it "does not create a user" do
        expect {
          post :create, params: create_params
        }.to_not change { User.count }
      end

      it "generates a flash failure message" do
        post :create, params: create_params
        expect(flash[:success]).to be_nil
        expect(flash[:error]).to include('problem')
      end

      it "re-renders the form with invalid user" do
        post :create, params: create_params
        expect(response).to render_template(:new)
      end
    end
  end
end
