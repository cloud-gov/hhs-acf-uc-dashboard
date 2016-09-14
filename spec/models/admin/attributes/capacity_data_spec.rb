require 'rails_helper'

RSpec.describe Admin::Attributes::CapacityData do
  let(:data) { Admin::Attributes::CapacityData.new(params) }

  context 'when the params are ok' do
    let(:params) {
      {
        funded: 100,
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
        funded: -100,
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
      expect(data.validation_errors.map(&:field)).to eq([:funded])
    end
  end

  describe '#normalized_status(status)' do
    context 'when status is "locked"' do
      let(:params) { {status: 'locked'} }

      it 'returns it' do
        expect(data.normalized_status).to eq('locked')
      end
    end

    context 'when status is "unlocked"' do
      let(:params) { {status: 'unlocked'} }

      it 'returns it' do
        expect(data.normalized_status).to eq('unlocked')
      end
    end

    context 'when it is something else' do
      let(:params) { {status: 'gerbil'} }

      it 'returns "unlocked"' do
        expect(data.normalized_status).to eq('unlocked')
      end
    end
  end
end
