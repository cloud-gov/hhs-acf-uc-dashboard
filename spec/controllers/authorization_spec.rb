require "rails_helper"

RSpec.describe Authorization do
  class MockController
    include Authorization

    def current_user(role=nil)
      @current_user ||= OpenStruct.new(role: role)
    end
  end

  context 'when current user has the right role' do
    let(:controller) {
      mock_controller = MockController.new
      mock_controller.current_user('admin')
      mock_controller
    }

    it '#can with permission request returns true' do
      expect(controller.can(:manage_users?)).to be true
    end

    it '#require! does not raise an error' do
      controller.require!(:can_manage_users)
      # no expectations, if it runs it passed
    end
  end

  context 'when current user does not have the needed role' do
    let(:controller) { MockController.new }

    it '#can with permission request returns false' do
      expect(controller.can(:manage_users?)).to be false
    end

    it '#require! raises an error' do
      expect(-> { controller.require!(:can_manage_users)}).to raise_error(Authorization::Error)
    end
  end
end
