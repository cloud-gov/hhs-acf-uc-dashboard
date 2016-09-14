require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe '#require!(:can_admin)' do
    context 'when there is no user' do
      let(:user) { nil }

      before do
        allow(controller).to receive(:current_user).and_return(user)
      end

      it 'raises an error' do
        expect { controller.require!(:can_admin) }.to raise_error(Authorization::Error)
      end
    end

    context 'when there is a no access user' do
      let(:user) { double(role: nil) }

      before do
        allow(controller).to receive(:current_user).and_return(user)
      end

      it 'raises an error' do
        expect { controller.require!(:can_admin) }.to raise_error(Authorization::Error)
      end
    end

    context 'when there is a general user' do
      let(:user) { double(role: 'general') }

      before do
        allow(controller).to receive(:current_user).and_return(user)
      end

      it 'raises an error' do
        expect { controller.require!(:can_admin) }.to raise_error(Authorization::Error)
      end
    end

    context 'when there is an operations user' do
      let(:user) { double(role: 'operations') }

      before do
        allow(controller).to receive(:current_user).and_return(user)
      end

      it 'raises an error' do
        expect { controller.require!(:can_admin) }.to raise_error(Authorization::Error)
      end
    end

    context 'when there is an admin user' do
      let(:user) { double(role: 'admin') }

      before do
        allow(controller).to receive(:current_user).and_return(user)
      end

      it 'does not raise an error' do
        controller.require!(:can_admin)
        # if it runs without error, it is good
      end
    end
  end
end
