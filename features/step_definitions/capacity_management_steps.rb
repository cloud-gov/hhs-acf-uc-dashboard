Then(/^I should see a link to the 'Capacity' page in the navigation bar$/) do
  within('.site-navbar .links') do
    expect(page).to have_content('Capacity')
  end
end

Given(/^I am an authenticated user that is not an 'admin' user$/) do
  step "I am a verified 'General' user"
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
  click_on 'Capacity'
end

Then(/^I should see yesterday's capacity values pre\-populated as today's values$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I will see prompts to verify or approve capacity values$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^there will be no notes in the capacity audit log$/) do
  pending # Write code here that turns the phrase above into concrete actions
end
