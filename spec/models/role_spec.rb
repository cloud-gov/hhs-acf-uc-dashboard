require "rails_helper"

RSpec.describe Role, type: :model do
  let(:role) { Role.new(user) }

  context "when the user role is 'admin'" do
    let(:user) { User.new(role: 'admin')}

    it "delegates to a role::Admin object" do
      expect(role.delegate_object).to be_a(Role::AdminRole)
    end

    it "can manager users" do
      expect(role.manage_users?).to be true
    end
  end

  context "when the user role is 'operations'" do
    let(:user) { User.new(role: 'operations')}

    it "delegates to a role::Operations object"  do
      expect(role.delegate_object).to be_a(Role::Operations)
    end

    it "cannot manager users" do
      expect(role.manage_users?).to be false
    end
  end

  context "when the user role is 'general'" do
    let(:user) { User.new(role: 'general')}

    it "delegates to a role::General object" do
      expect(role.delegate_object).to be_a(Role::General)
    end

    it "cannot manager users" do
      expect(role.manage_users?).to be false
    end
  end

  context "when the user role is nil" do
    let(:user) { User.new() }

    it "delegates to a role::None object" do
      expect(role.delegate_object).to be_a(Role::None)
    end

    it "cannot manager users" do
      expect(role.manage_users?).to be false
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
