Given(/^I am a user with permission to view the dashboard$/) do
  step "I have signed in as an authenticated 'Admin' user"
end

Given(/^capacity numbers were locked yesterday, but not today$/) do
  @yesterdays_capacity = Capacity.create({
    date: Date.today - 1,
    funded: 100,
    reserve: 200,
    activated: 300,
    unavailable: 400,
    status: 'locked'
  })

  @todays_capacity = Capacity.create({
    date: Date.today,
    funded: 1000,
    reserve: 2000,
    activated: 3000,
    unavailable: 4000,
    status: 'unlocked'
  })
end

When(/^I visit 'Daily' report page$/) do
  @daily_statistics = {
    discharges: 15,
    in_care: 4500,
    referrals: 32
  }

  RSpec::Mocks.with_temporary_scope do
    allow(RestClient).to receive(:get).and_return(@daily_statistics)
    click_on "Daily"
  end
end

Then(/^I should see yesterday's daily report$/) do
  expect(page).to have_content(@yesterdays_capacity.date.strftime('%B %-d, %Y'))
end

Given(/^capacity numbers have alreday been locked today$/) do
  @yesterdays_capacity = Capacity.create({
    date: Date.today - 1,
    funded: 100,
    reserve: 200,
    activated: 300,
    unavailable: 400,
    status: 'locked'
  }) # just for safety check

  @todays_capacity = Capacity.create({
    date: Date.today,
    funded: 1000,
    reserve: 2000,
    activated: 3000,
    unavailable: 4000,
    status: 'locked'
  })
end

Then(/^I should see today's daily report$/) do
  within('h2') do
    expect(page).to have_content(@todays_capacity.date.strftime('%B %-d, %Y'))
  end
end

When(/^I open the date selector menu for the daily report$/) do
  find('select.report-date').click
end

Then(/^I should see all report dates in the dashboard including today$/) do
  within('select.report-date') do
    expect(page).to have_selector("option[value='#{@yesterdays_capacity.date.strftime('%Y-%m-%d')}']")
    expect(page).to have_selector("option[value='#{@todays_capacity.date.strftime('%Y-%m-%d')}']")
  end
end

When(/^I select another locked day from the date selector menu$/) do
  find('select.report-date').find("option[value='#{@yesterdays_capacity.date.strftime('%Y-%m-%d')}']").select_option
end

Then(/^I should be taken to that day's report$/) do
  within('h2') do
    expect(page).to have_content(@yesterdays_capacity.date.strftime('%B %-d, %Y'))
  end
end

When(/^I choose (.+) from report type selector$/) do |report_type|
  find('select.report-type').find("option[value=#{report_type.downcase}]").select_option
end

Then(/^I should not see a select for the report type$/) do
  expect(page).to_not have_selector('select.report-type')
end

Given(/^capacity numbers have not been locked for the day$/) do
  @todays_capacity = Capacity.create({
    date: Date.today,
    funded: 1000,
    reserve: 2000,
    activated: 3000,
    unavailable: 4000,
    status: 'unlocked'
  })
end

Then(/^I should see a message that there is no data available$/) do
  expect(page).to have_content('not yet available')
end

