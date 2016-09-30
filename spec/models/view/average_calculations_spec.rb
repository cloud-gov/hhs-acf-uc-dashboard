require "rails_helper"

RSpec.describe View::AverageCalculations do
  let(:report) {
    View::AverageCalculations.new(data)
  }

  it 'calculates the 7 day average discharge rate' do
    seven_day_average =  (20 + 13 + 12 + 18 + 5 + 7 + 12).to_f / (4500 + 4502 + 4510 + 4507 + 4502 + 4510 + 4520)
    expect(report.seven_day_discharge_average).to eq(seven_day_average)
  end

  it 'calculates the 7 day per 100 kids' do
    expect(report.seven_day_discharge_average_per_hundred).to eq(0.3)
  end

  let(:data) {
    [
      OpenStruct.new({
        discharges: 20, in_care: 4500
      }),
      OpenStruct.new({
        discharges: 13, in_care: 4502
      }),
      OpenStruct.new({
        discharges: 12, in_care: 4510
      }),
      OpenStruct.new({
        discharges: 18, in_care: 4507
      }),
      OpenStruct.new({
        discharges: 5, in_care: 4502
      }),
      OpenStruct.new({
        discharges: 7, in_care: 4510
      }),
      OpenStruct.new({
        discharges: 12, in_care: 4520
      }),
      OpenStruct.new({
        discharges: 33, in_care: 4600
      }),
      OpenStruct.new({
        discharges: 22, in_care: 4610
      }),
      OpenStruct.new({
        discharges: 27, in_care: 4606
      }),
      OpenStruct.new({
        discharges: 28, in_care: 4610
      }),
      OpenStruct.new({
        discharges: 11, in_care: 4626
      }),
      OpenStruct.new({
        discharges: 12, in_care: 4627
      }),
      OpenStruct.new({
        discharges: 15, in_care: 4620
      }),
      OpenStruct.new({
        discharges: 18, in_care: 4603
      }),
      OpenStruct.new({
        discharges: 30, in_care: 4602
      }),
      OpenStruct.new({
        discharges: 25, in_care: 4606
      }),
      OpenStruct.new({
        discharges: 23, in_care: 4606
      }),
      OpenStruct.new({
        discharges: 25, in_care: 4602
      }),
      OpenStruct.new({
        discharges: 20, in_care: 4608
      }),
      OpenStruct.new({
        discharges: 20, in_care: 4615
      }),
      OpenStruct.new({
        discharges: 20, in_care: 4618
      }),
      OpenStruct.new({
        discharges: 20, in_care: 4616
      }),
      OpenStruct.new({
        discharges: 20, in_care: 4620
      }),
      OpenStruct.new({
        discharges: 20, in_care: 4622
      }),
      OpenStruct.new({
        discharges: 20, in_care: 4618
      }),
      OpenStruct.new({
        discharges: 20, in_care: 4615
      }),
      OpenStruct.new({
        discharges: 20, in_care: 4620
      }),
      OpenStruct.new({
        discharges: 20, in_care: 4630
      }),
      OpenStruct.new({
        discharges: 20, in_care: 4610
      })
    ]
  }
end
