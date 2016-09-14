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

  before do
    allow(controller).to receive(:current_user).and_return(admin)
  end

  describe "GET #index" do
    it "requires authenticated user" do
      expect(controller).to receive(:authenticate_user!)
      expect(controller).to receive(:require!).with(:can_admin)
      get :index
    end
  end

  describe "GET #show id: 'current'" do
    it "requires authenticated user" do
      expect(controller).to receive(:authenticate_user!)
      expect(controller).to receive(:require!).with(:can_admin)
      get :show, params: {id: 'current'}
      expect(response).to have_http_status(:success)
    end
  end

  describe "PUT #update" do
    before do
      allow(controller).to receive(:authenticate_user!)
      allow(controller).to receive(:require!)
    end

    let(:capacity_params) {
      {
        id: '2016-09-06',
        capacity: {
          funded: 1001,
          reserve: 101,
          activated: 202,
          unavailable: 333,
          status: 'locked'
        }
      }
    }

    it 'requires authenticated user' do
      expect(controller).to receive(:authenticate_user!)
      expect(controller).to receive(:require!).with(:can_admin)
      put :update, params: capacity_params
      expect(response).to redirect_to('/admin/capacities/current')
    end

    describe 'successful saves' do
      it 'creates a new record, when the record does not exist' do
        expect {
          put :update, params: capacity_params
        }.to change { Capacity.count }.by(1)
      end

      it 'updates the record when one exists with that date' do
        capacity = Capacity.create({
          date: '2016-09-06',
          funded: 1,
          reserve: 2,
          activated: 3,
          unavailable: 4,
          status: 'unlocked'
        })

        put :update, params: capacity_params

        capacity.reload
        expect(capacity.funded).to eq(1001)
        expect(capacity.reserve).to eq(101)
        expect(capacity.activated).to eq(202)
        expect(capacity.unavailable).to eq(333)
        expect(capacity.status).to eq('locked')
        expect(capacity.date).to eq(Date.parse('2016-09-06'))
      end

      it "flashes a success message" do
        put :update, params: capacity_params
        expect(flash[:success]).to include('saved')
      end
    end

    describe "invalid params" do
      let(:capacity_params) {
        {
          id: '2016-09-06',
          capacity: {
            funded: -1001,
            reserve: 101,
            activated: 202,
            unavailable: 333,
            status: 'locked'
          }
        }
      }

      it 'does not create a record' do
        expect {
          put :update, params: capacity_params
        }.to_not change { Capacity.count }
      end

      it 'flashes a failure message' do
        put :update, params: capacity_params
        expect(flash[:error]).to_not be_nil
      end

      it 'renders the show page' do
        put :update, params: capacity_params
        expect(response).to render_template(:show)
        expect(response).to have_http_status(200)
      end
    end
  end
end

