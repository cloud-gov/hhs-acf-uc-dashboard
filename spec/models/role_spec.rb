require "rails_helper"

RSpec.describe Role, type: :model do
  let(:role) { Role.new(user) }

  context "when the user role is 'admin'" do
    let(:user) { User.new(role: 'admin')}

    it "delegates to a role::Admin object" do
      expect(role.delegate_object).to be_a(Role::AdminRole)
    end

    it "can admin the app" do
      expect(role.admin?).to be true
    end

    it "#report_type will be 'operations' if nothing valid is provided" do
      expect(role.report_type(nil)).to eq('operations')
    end

    it "#report_type will be any of the valid report types if asked for" do
      expect(role.report_type('general')).to eq('general')
    end
  end

  context "when the user role is 'operations'" do
    let(:user) { User.new(role: 'operations')}

    it "delegates to a role::Operations object"  do
      expect(role.delegate_object).to be_a(Role::Operations)
    end

    it "cannot admin the app" do
      expect(role.admin?).to be false
    end

    it "#report_type will always return 'operations'" do
      expect(role.report_type(nil)).to eq('operations')
      expect(role.report_type('general')).to eq('operations')
      expect(role.report_type('operations')).to eq('operations')
    end
  end

  context "when the user role is 'general'" do
    let(:user) { User.new(role: 'general')}

    it "delegates to a role::General object" do
      expect(role.delegate_object).to be_a(Role::General)
    end

    it "cannot admin the app" do
      expect(role.admin?).to be false
    end

    it "#report_type will always return 'general'" do
      expect(role.report_type(nil)).to eq('general')
      expect(role.report_type('general')).to eq('general')
      expect(role.report_type('operations')).to eq('general')
    end
  end

  context "when the user role is nil" do
    let(:user) { User.new() }

    it "delegates to a role::None object" do
      expect(role.delegate_object).to be_a(Role::None)
    end

    it "cannot admin the app" do
      expect(role.admin?).to be false
    end
  end

  context "when the user role is unknown" do
    let(:user) { User.new(role: 'king') }

    it "delegates to a role::None object" do
      expect(role.delegate_object).to be_a(Role::None)
    end
  end

  context 'when there is no user' do
    let(:user) { nil }

    it "delegates to the Role::None object" do
      expect(role.delegate_object).to be_a(Role::None)
    end
  end
end
