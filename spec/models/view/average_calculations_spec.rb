require "rails_helper"

RSpec.describe View::AverageCalculations do
  let(:report) {
    View::AverageCalculations.new(data)
  }

  it 'calculates the 7 day average discharge ratio (to in care)' do
    seven_day_average =  (20 + 13 + 12 + 18 + 5 + 7 + 12).to_f / (4500 + 4502 + 4510 + 4507 + 4502 + 4510 + 4520)
    expect(report.seven_day_discharge_ratio_average).to eq(seven_day_average)
  end

  it 'calculates the 7 day per 100 kids' do
    expect(report.seven_day_discharge_average_per_hundred).to eq(0.3)
  end

  it 'calculates the 7 day average' do
    expect(report.seven_day_discharge_average).to eq(((20+13+12+18+5+7+12)/7).round)
  end

  it 'calculates the percentage change is discharges 7 days vs 30' do
    expect(report.week_vs_month_discharge_average_percentage).to eq("-37%")
  end

  it 'calculates the 7 day referrals average' do
    expect(report.seven_day_referrals_average).to eq(((100+89+92+87+90+67+102)/7.0).round)
  end

  let(:data) {
    [
      OpenStruct.new({
        discharges: 20, in_care: 4500, referrals: 100
      }),
      OpenStruct.new({
        discharges: 13, in_care: 4502, referrals: 89
      }),
      OpenStruct.new({
        discharges: 12, in_care: 4510, referrals: 92
      }),
      OpenStruct.new({
        discharges: 18, in_care: 4507, referrals: 87
      }),
      OpenStruct.new({
        discharges: 5, in_care: 4502, referrals: 90
      }),
      OpenStruct.new({
        discharges: 7, in_care: 4510, referrals: 67
      }),
      OpenStruct.new({
        discharges: 12, in_care: 4520, referrals: 102
      }),
      OpenStruct.new({
        discharges: 33, in_care: 4600, referrals: 90
      }),
      OpenStruct.new({
        discharges: 22, in_care: 4610, referrals: 66
      }),
      OpenStruct.new({
        discharges: 27, in_care: 4606, referrals: 68
      }),
      OpenStruct.new({
        discharges: 28, in_care: 4610, referrals: 67
      }),
      OpenStruct.new({
        discharges: 11, in_care: 4626, referrals: 89
      }),
      OpenStruct.new({
        discharges: 12, in_care: 4627, referrals: 92
      }),
      OpenStruct.new({
        discharges: 15, in_care: 4620, referrals: 102
      }),
      OpenStruct.new({
        discharges: 18, in_care: 4603, referrals: 110
      }),
      OpenStruct.new({
        discharges: 30, in_care: 4602, referrals: 103
      }),
      OpenStruct.new({
        discharges: 25, in_care: 4606, referrals: 90
      }),
      OpenStruct.new({
        discharges: 23, in_care: 4606, referrals: 105
      }),
      OpenStruct.new({
        discharges: 25, in_care: 4602, referrals: 101
      }),
      OpenStruct.new({
        discharges: 20, in_care: 4608, referrals: 90
      }),
      OpenStruct.new({
        discharges: 20, in_care: 4615, referrals: 85
      }),
      OpenStruct.new({
        discharges: 20, in_care: 4618, referrals: 100
      }),
      OpenStruct.new({
        discharges: 20, in_care: 4616, referrals: 86
      }),
      OpenStruct.new({
        discharges: 20, in_care: 4620, referrals: 83
      }),
      OpenStruct.new({
        discharges: 20, in_care: 4622, referrals: 70
      }),
      OpenStruct.new({
        discharges: 20, in_care: 4618, referrals: 66
      }),
      OpenStruct.new({
        discharges: 20, in_care: 4615, referrals: 69
      }),
      OpenStruct.new({
        discharges: 20, in_care: 4620, referrals: 70
      }),
      OpenStruct.new({
        discharges: 20, in_care: 4630, referrals: 72
      }),
      OpenStruct.new({
        discharges: 20, in_care: 4610, referrals: 76
      })
    ]
  }
end
