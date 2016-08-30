require 'rails_helper'

RSpec.describe DashboardsController, type: :controller do
  describe 'GET #index' do
    it "requires authentication" do
      expect(controller).to receive(:authenticate_user!)
      get :index
    end

    it "redirects to the default dashboard" do
      user = double(role: 'admin')
      expect(controller).to receive(:authenticate_user!)
      allow(controller).to receive(:current_user).and_return(user)
      get :index
      expect(controller).to redirect_to('/dashboards/default')
    end
  end

  describe "GET #show" do
    let(:user_attributes) { {email: 'user@hhs.gov', password: 'password', password_confirmation: 'password'} }
    let(:user) {
      User.create!(user_attributes.merge({role: role}))
    }
    let(:role) { nil } # changes in each context

    it "requires authentication" do
      expect(controller).to receive(:authenticate_user!)
      get :show, params: {id: 'whatever'}
    end

    describe 'a no access user' do
      before do
        allow(controller).to receive(:authenticate_user!)
        allow(controller).to receive(:current_user).and_return(user)
      end

      it "only shows the no-access message" do
        get :show, params: {id: 'operations'}
        expect(response).to render_template('no-access')

        get :show, params: {id: 'no-access'}
        expect(response).to render_template('no-access')

        get :show, params: {id: 'something-weird'}
        expect(response).to render_template('no-access')
      end
    end

    describe 'a general user' do
      let(:role) { 'general' }

      before do
        allow(controller).to receive(:authenticate_user!)
        allow(controller).to receive(:current_user).and_return(user)
      end

      it "only shows the general dashboard" do
        get :show, params: {id: 'operations'}
        expect(response).to render_template("general")

        get :show, params: {id: 'general'}
        expect(response).to render_template("general")

        get :show, params: {id: 'something-weird'}
        expect(response).to render_template("general")
      end
    end

    describe 'as operations user' do
      let(:role) { 'operations' }

      before do
        allow(controller).to receive(:authenticate_user!)
        allow(controller).to receive(:current_user).and_return(user)
      end

      it "only shows the operations dashboard" do
        get :show, params: {id: 'operations'}
        expect(response).to render_template("operations")

        get :show, params: {id: 'general'}
        expect(response).to render_template("operations")

        get :show, params: {id: 'something-weird'}
        expect(response).to render_template("operations")
      end
    end

    describe 'as admin user' do
      let(:role) { 'admin' }

      before do
        allow(controller).to receive(:authenticate_user!)
        allow(controller).to receive(:current_user).and_return(user)
      end

      it "can see the operations dashboard" do
        get :show, params: {id: 'operations'}
        expect(response).to render_template("operations")
      end

      it "can see the general dashboard" do
        get :show, params: {id: 'general'}
        expect(response).to render_template("general")
      end

      it "defaults to the operations dashboard" do
        get :show, params: {id: 'something-weird'}
        expect(response).to render_template("operations")
      end
    end
  end
end
