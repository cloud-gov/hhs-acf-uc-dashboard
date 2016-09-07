require 'rails_helper'

RSpec.describe Admin::CapacityData do
  let(:data) { Admin::CapacityData.new(params) }

  context 'when the params are ok' do
    let(:params) {
      {
        standard: 100,
        reserve: '100',
        activated: '17',
        unavailable: 333,
        status: 'locked'
      }
    }

    it '#valid? returns true' do
      expect(data.valid?).to equal(true)
    end

    it "#validation_errors returns an empty array" do
      expect(data.validation_errors).to be_empty
    end
  end

  context 'when containing negative numbers' do
    let(:params) {
      {
        standard: -100,
        reserve: nil,
        activated: 'gerbil',
        unavailable: 333,
        status: 'locked'
      }
    }

    it "#valid? returns false" do
      expect(data.valid?).to equal(false)
    end

    it "#validation_errors returns an array of errors" do
      expect(data.validation_errors.size).to eq(1)
      expect(data.validation_errors.map(&:field)).to eq([:standard])
    end
  end
end
