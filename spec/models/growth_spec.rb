require 'rails_helper'

RSpec.describe Growth do
  let(:growth) { Growth.new(history) }
  let(:history) {
    [183, 179, 197, 203, 252, 253, 187, 180, 138, 163, 203, 143, 193, 150, 147, 156, 154, 185, 182, 183, 179, 197, 203, 252, 253, 187, 180, 138, 163, 203, 143, 193, 150, 147, 156, 154, 185, 182].map do |n|
      OpenStruct.new(referrals: n)
    end
  }

  # See spreadsheet: https://docs.google.com/a/gsa.gov/spreadsheets/d/1Sd2X-oqqei-fgzATZ37H813IpOVld7JsTSQZWXez6ko/edit?usp=sharing
  # for calculation confirmation
  it 'averages' do
    #-0.4952764977
    expect(growth.calculate.round(4)).to eq(-0.4953)
  end
end
