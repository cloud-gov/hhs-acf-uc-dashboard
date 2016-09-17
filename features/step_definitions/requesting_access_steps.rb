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
  @email ||= 'asker@hhs.gov'
  fill_in('Email', :with => @email)
end

When(/^I fill in my password$/) do
  @password ||= 's3kr3t111'
  fill_in('Password', :with => @password)
end

When(/^I fill in and confirm a password$/) do
  step "I fill in my password"
  fill_in('Password confirmation', :with => @password)
end

When(/^I click to submit$/) do
  click_button('Submit request')
end

Then(/^I should see a message telling me I need to verify my email$/) do
  expect(page).to have_content("A message with a confirmation link has been sent to your email address")
end

Then(/^I receive an email asking me to verify my email address$/) do
  mail = ActionMailer::Base.deliveries.last
  expect(mail.to.first).to eq(@email)
end

Given(/^I have requested access to the dashboard$/) do
  step "I visit the home page"
  step "I click the link to request access"
  step "I fill in my email"
  step "I fill in and confirm a password"
  step "I click to submit"
end

When(/^I click on the verification link in the email$/) do
  user = User.where(email: @email).first
  visit "/users/confirmation?confirmation_token=#{user.confirmation_token}"
end

Then(/^I should see a message that my participation is being reviewed$/) do
  expect(page).to have_content(/your participation is being reviewed/i)
end

Then(/^I will see a message that my email is confirmed$/) do
  expect(page).to have_content(/Your email address has been successfully confirmed/i)
end

When(/^I sign in as an unverified user with my credentials$/) do
  step "I sign in"
end

When(/^I sign in$/) do
  step "I fill in my email"
  step "I fill in my password"
  click_button "Sign in"
end
