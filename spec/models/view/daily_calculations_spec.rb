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
    #4647[In care] divided by ( 7123[funded capacity] + 1500[reserve] + 510[activated] ) I get .5088 but the Daily page displays 54%
    data.in_care = 4647
    data.funded = 7123
    data.reserve = 1500
    data.activated = 510
    expect(report.reserved_rate).to eq('51%') # in_care / (funded + reserve + activated) to percentage - 4500/(4400 + 3000)
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

  it 'calculates #current_funded_capacity' do
    # funded + activated
    expect(report.current_funded_capacity).to eq(4400 + 250)
  end

  it 'calculates #total_reserve_capacity' do
    # funded + activated + reserve
    expect(report.total_reserve_capacity).to eq(4400 + 250 + 3000)
  end

  it 'calculates #funded_percentage' do
    # in_care / funded
    expect(report.funded_percentage).to eq("102%")
  end

  it 'calculates #funded_available_percentage' do
    expect(report.funded_available_percentage).to eq("104%")
  end
end
