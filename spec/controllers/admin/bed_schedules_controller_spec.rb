require 'rails_helper'

RSpec.describe Admin::BedSchedulesController, type: :controller do
  before do
    allow(controller).to receive(:authenticate_user!)
    allow(controller).to receive(:require!)
  end

  describe "POST #create" do
    let(:schedule_params) {
      {
        bed_schedule: {
          facility_name: 'Homestead',
          bed_count: '304',
          month: '10',
          day: '03',
          year: '2016'
        }
      }
    }

    it "requires authenticated and authorized user" do
      expect(controller).to receive(:authenticate_user!)
      expect(controller).to receive(:require!).with(:can_admin)
      post :create, params: schedule_params
    end

    it "creates a new schedule record" do
      expect {
        post :create, params: schedule_params
      }.to change { BedSchedule.count }
    end

    it 'flashes a success message' do
      post :create, params: schedule_params
      expect(flash[:success]).to_not be_nil
    end

    describe 'with invalid params' do
      let(:schedule_params) {
        {
          bed_schedule: {
            facility_name: 'Homestead',
            bed_count: '-304',
            month: '44',
            day: '03',
            year: '2016'
          }
        }
      }

      it 'flashes an error' do
        post :create, params: schedule_params
        expect(flash[:error]).to_not be_nil
      end

      it 'renders the current capacities page' do
        post :create, params: schedule_params
        expect(response).to render_template('capacities/show')
      end
    end
  end
end

