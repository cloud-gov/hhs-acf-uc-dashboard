require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'GET #index' do
    context 'when not logged in' do
      it 'renders the template' do
        get :index
        expect(response).to render_template(:index)
      end
    end

    context 'when logged in as an admin' do
      let(:user) { double(role: 'admin') }

      it 'redirects to capacities' do
        allow(controller).to receive(:current_user).and_return(user)
        get :index
        expect(response).to redirect_to('/admin/capacities/current')
      end
    end

    context 'when logged in as something else' do
      let(:user) { double(role: 'no access') }

      it 'redirects to the default report' do
        allow(controller).to receive(:current_user).and_return(user)
        get :index
        expect(response).to redirect_to('/reports')
      end
    end
  end
end

