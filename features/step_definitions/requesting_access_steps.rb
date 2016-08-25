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
  @unknown_email = 'asker@hhs.gov'
  fill_in('Email', :with => @unknown_email)
end

When(/^I fill in and confirm a password$/) do
  fill_in('Password', :with => 's3kr3t')
  fill_in('Password confirmation', :with => 's3kr3t')
end

When(/^I click to submit$/) do
  click_button('Submit request')
end

Then(/^I should see a message telling me I need to verify my email$/) do
  expect(page).to have_content("A message with a confirmation link has been sent to your email address")
end

Then(/^I receive an email asking me to verify my email address$/) do
  mail = ActionMailer::Base.deliveries.last
  expect(mail.to.first).to eq(@unknown_email)
end

Given(/^I have requested access to the dashboard$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

When(/^I click on the verification link in the email$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I should see a message that my participation is being reviewed$/) do
  pending # Write code here that turns the phrase above into concrete actions
end
