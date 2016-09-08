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
    standard: 1,
    reserve: 2,
    activated: 3,
    unavailable: 4,
    status: 'locked',
    date: Date.today - 1
  })
  click_on 'Capacity'
end

Then(/^I should see yesterday's capacity values pre\-populated as today's values$/) do
  expect(find('#capacity_standard').value).to eq(@previous_capacity.standard.to_s)
  expect(find('#capacity_activated').value).to eq(@previous_capacity.activated.to_s)
  expect(find('#capacity_unavailable').value).to eq(@previous_capacity.unavailable.to_s)
end

Then(/^I should see the capacity values are unlocked$/) do
  expect(find('#capacity_status').value).to eq('unlocked')
end

Then(/^I should see that the capacity values are for today's date$/) do
  within('.field.date') do
    expect(page).to have_content(Date.today.strftime('%m/%d/%y'))
  end
end

Then(/^there will be no notes in the capacity audit log$/) do
  expect(page).to_not have_selector('.audit-logs .audit-log')
end

When(/^I update intake values$/) do
  @new_intake_values = OpenStruct.new({
    standard: 100,
    reserve: 200,
    activated: 300,
    unavailable: 400,
  })
  fill_in('Standard', with: @new_intake_values.standard)
  fill_in('Reserve', with: @new_intake_values.reserve)
  fill_in('Activated', with: @new_intake_values.activated)
  fill_in('Unavailable', with: @new_intake_values.unavailable)
  click_on("Save")
end

Then(/^I will see the capacity values have been modified from yesterday$/) do
  expect(find('#capacity_standard').value).to eq(@new_intake_values.standard.to_s)
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
  expect(find('#capacity_standard')).to be_readonly
  expect(find('#capacity_reserve')).to be_readonly
  expect(find('#capacity_unavailable')).to be_readonly
  expect(find('#capacity_activated')).to be_readonly
end

Then(/^I will see the capacity form is unlocked$/) do
  expect(find('#capacity_standard')).to_not be_readonly
  expect(find('#capacity_reserve')).to_not be_readonly
  expect(find('#capacity_unavailable')).to_not be_readonly
  expect(find('#capacity_activated')).to_not be_readonly
end
