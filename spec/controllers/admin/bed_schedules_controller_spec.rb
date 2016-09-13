require 'rails_helper'

RSpec.describe Admin::BedSchedulesController, type: :controller do
  before do
    allow(controller).to receive(:authenticate_user!)
    allow(controller).to receive(:require!)
  end

  describe "POST #create" do
    describe 'with valid params' do
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

  describe 'PUT #update' do
    let!(:schedule) {
      BedSchedule.create({
        facility_name: 'Homestead',
        bed_count: '304',
        scheduled_on: Date.parse('2016-10-3')
      })
    }

    describe 'with valid params' do
      let(:schedule_params) {
        {
          id: schedule.id,
          bed_schedule: {
            facility_name: 'Homestead (Round 1)',
            bed_count: '305',
            month: '10',
            day: '3',
            year: '2016'
          }
        }
      }

      it "requires authenticated and authorized user" do
        expect(controller).to receive(:authenticate_user!)
        expect(controller).to receive(:require!).with(:can_admin)
        put :update, params: schedule_params
        expect(response).to redirect_to('/admin/capacities/current')
      end

      it "creates a updates the scheduled record" do
        expect {
          put :update, params: schedule_params
        }.to_not change { BedSchedule.count }
        schedule.reload
        expect(schedule.facility_name).to eq('Homestead (Round 1)')
        expect(schedule.bed_count).to eq(305)
      end

      it 'flashes a success message' do
        put :update, params: schedule_params
        expect(flash[:success]).to_not be_nil
      end
    end

    describe 'with invalid params' do
      let(:schedule_params) {
        {
          id: schedule.id,
          bed_schedule: {
            facility_name: 'Homestead, say what?',
            bed_count: '-305',
            month: '10',
            day: '3',
            year: '2016'
          }
        }
      }

      it 'does not update the attributes' do
        put :update, params: schedule_params
        expect(schedule.reload.facility_name).to eq('Homestead')
      end

      it 'flashes an error' do
        put :update, params: schedule_params
        expect(flash[:error]).to_not be_nil
      end

      it 'renders the current capacities page' do
        put :update, params: schedule_params
        expect(response).to render_template('capacities/show')
      end
    end
  end
end

