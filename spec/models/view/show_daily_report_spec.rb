require "rails_helper"

RSpec.describe View::ShowDailyReport do
  let(:report) {
    View::ShowDailyReport.new(querier)
  }

  let(:querier) {
    double({
      role: 'admin',
      date: Date.today,
      referals: 220,
      discharges: 200,
      in_care: 4500,
      capacity: capacity
    })
  }

  let(:capacity) {
    Capacity.new({
      funded: 4400,
      activated: 250,
      reserve: 400,
      unavailable: 80
    })
  }

  it 'calculates open beds' do
    expect(report.open_beds).to eq(150) # funded + activated - in care = 4400+250-4500
  end
end
