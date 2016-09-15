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
  click_on "Daily"
end

Then(/^I should see yesterday's daily report$/) do
  expect(page).to have_content(@yesterdays_capacity.date.strftime('%B %-d, %Y'))
end
