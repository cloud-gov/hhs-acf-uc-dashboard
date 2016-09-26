require "rails_helper"

RSpec.describe View::DailyCalculations do
  let(:report) {
    View::DailyCalculations.new(data)
  }

  let(:data) {
    OpenStruct.new({
      referals: 220,
      discharges: 200,
      in_care: 4500,
      funded: 4400,
      activated: 250,
      reserve: 3000,
      unavailable: 80
    })
  }

  it 'calculates open beds' do
    expect(report.open_beds).to eq(150) # funded + activated - in care = 4400+250-4500
  end

  it 'calculates and presents the activated rate' do
    expect(report.activated_rate).to eq('97%') # in_care / (funded + activated) to percentage - 4500/(4400 + 250)
  end

  it 'calculates and presents the reserve rate' do
    expect(report.reserved_rate).to eq('61%') # in_care / (funded + reserve) to percentage - 4500/(4400 + 3000)
  end

  it 'creates an alert status for calculations in the error range' do
    expect(report.activated_rate_status).to eq('alert')
  end

  it 'creates an alert status for calculations in the good range' do
    expect(report.reserved_rate_status).to eq('notice')
  end

  it 'creates an alert status for calculation in the warning range' do
    data.reserve = 2000
    expect(report.reserved_rate_status).to eq('warn')
  end
end
