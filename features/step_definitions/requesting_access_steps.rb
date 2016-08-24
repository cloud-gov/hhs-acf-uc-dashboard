Given(/^I am an unverified user$/) do
  # no-op
end

When(/^I visit the home page$/) do
  visit "/"
end

Then(/^I should see a link to request access$/) do
  expect(page).to have_content 'request access'
end

When(/^I click the link to request access$/) do
  click_link('request access')
end

When(/^I fill in my email$/) do
  fill_in('Email', :with => 'asker@hhs.gov')
end

When(/^I fill in and confirm a password$/) do
  fill_in('Password', :with => 's3kr3t')
  fill_in('Confirm Password', :with => 's3kr3t')
end

When(/^I click to submit$/) do
  click_button('Submit request')
end

Then(/^I should see a message telling me I need to verify my email$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I receive an email asking me to verify my email address$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Given(/^I have requested access to the dashboard$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Given(/^I receive an email asking me to verify my email address$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

When(/^I click on the verification link in the email$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I should see a message that my participation is being reviewed$/) do
  pending # Write code here that turns the phrase above into concrete actions
end
