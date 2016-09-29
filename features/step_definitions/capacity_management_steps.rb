Then(/^I should see a link to the 'Capacity' page in the navigation bar$/) do
  within('.site-navbar .links') do
    expect(page).to have_content('Capacity')
  end
end

Given(/^I have signed in as an authenticated user that is not an 'admin' user$/) do
  step "I am a verified 'General' user"
  step "I visit the home page"
  step "I sign in"
end

Then(/^I should not see a link to the 'Capacity' page in the navigation bar$/) do
  within('.site-navbar .links') do
    expect(page).to_not have_content('Capacity')
  end
end

Given(/^no other user has already modified the daily intake values$/) do
  # no-op
end

When(/^I click on the 'Capacity' link$/) do
  @previous_capacity ||= Capacity.create({
    funded: 1,
    reserve: 2,
    activated: 3,
    unavailable: 4,
    status: 'locked',
    date: Date.today - 1
  })
  click_on 'Capacity'
end

Then(/^I should see yesterday's capacity values pre\-populated as today's values$/) do
  expect(find('#capacity_funded').value).to eq(@previous_capacity.funded.to_s)
  expect(find('#capacity_activated').value).to eq(@previous_capacity.activated.to_s)
  expect(find('#capacity_unavailable').value).to eq(@previous_capacity.unavailable.to_s)
end

Then(/^I should see the capacity values are unlocked$/) do
  expect(find('#capacity_status').value).to eq('unlocked')
end

Then(/^I should see that the capacity values are for today's date$/) do
  within('.field.date') do
    expect(page).to have_content(Date.today.strftime('%m/%-d/%y'))
  end
end

Then(/^there will be no notes in the capacity audit log$/) do
  expect(page).to_not have_selector('.audit-logs .audit-log')
end

When(/^I update intake values$/) do
  @new_intake_values = OpenStruct.new({
    funded: 100,
    reserve: 200,
    activated: 300,
    unavailable: 400,
  })
  fill_in('Funded capacity', with: @new_intake_values.funded)
  fill_in('Reserve', with: @new_intake_values.reserve)
  fill_in('Activated', with: @new_intake_values.activated)
  fill_in('Unavailable', with: @new_intake_values.unavailable)
  click_on("Save")
end

Then(/^I will see the capacity values have been modified from yesterday$/) do
  expect(find('#capacity_funded').value).to eq(@new_intake_values.funded.to_s)
  expect(find('#capacity_reserve').value).to eq(@new_intake_values.reserve.to_s)
  expect(find('#capacity_activated').value).to eq(@new_intake_values.activated.to_s)
  expect(find('#capacity_unavailable').value).to eq(@new_intake_values.unavailable.to_s)
end

Then(/^I will see a capacity audit log noting the change$/) do
  within('.audit-logs .audit-log') do
    expect(page).to have_content("#{@admin.email} updated intake values")
  end
end

When(/^I change the status to (locked|unlocked) and save capacity$/) do |status|
  find('select').find(:option, status).select_option
  click_on('Save')
end

Then(/^I will see a note about (locking|unlocking) the capacity$/) do |status|
  within('.audit-logs') do
    expect(page).to have_content(status.sub('ing', 'ed'))
  end
end

Then(/^I will see the capacity form is locked$/) do
  expect(find('#capacity_funded')).to be_readonly
  expect(find('#capacity_reserve')).to be_readonly
  expect(find('#capacity_unavailable')).to be_readonly
  expect(find('#capacity_activated')).to be_readonly
end

Then(/^I will see the capacity form is unlocked$/) do
  expect(find('#capacity_funded')).to_not be_readonly
  expect(find('#capacity_reserve')).to_not be_readonly
  expect(find('#capacity_unavailable')).to_not be_readonly
  expect(find('#capacity_activated')).to_not be_readonly
end

When(/^I click to view the 'Bed capacity history'$/) do
  click_on('Bed capacity history')
end

Given(/^there are capacity records in the past$/) do
  @previous_capacity ||= Capacity.create({
    funded: 1,
    reserve: 2,
    activated: 3,
    unavailable: 4,
    status: 'locked',
    date: Date.today - 3
  })
end

Given(/^the API is available$/) do
  @daily_statistics = double('response', body: {
    discharges: 15,
    in_care: 1500,
    referrals: 32
  }.to_json)
  allow(RestClient).to receive(:get).and_return(@daily_statistics)
end

Then(/^I will see a list of all dates since the first recorded capacity in reverse chronological order$/) do
  expect(page).to have_content(Date.today.strftime('%m/%-d/%y'))
  expect(page).to have_content((Date.today - 1).strftime('%m/%-d/%y'))
  expect(page).to have_content((Date.today - 2).strftime('%m/%-d/%y'))
  expect(page).to have_content((Date.today - 3).strftime('%m/%-d/%y'))
end

Then(/^My API cached values will be saved$/) do
  capacity = Capacity.where(reported_on: Date.today).take
  expect(capacity.in_care).to eq(1500)
  expect(capacity.referrals).to eq(32)
  expect(capacity.discharges).to eq(15)
end

Then(/^I should see an alert that information could not be cached from the API$/) do
  expect(page).to have_content("Unable to cache data from the API")
end

