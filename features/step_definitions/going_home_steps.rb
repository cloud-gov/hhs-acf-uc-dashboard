Given(/^I am an authenticated 'General' user$/) do
  @email = 'general@hhs.gov'
  @password = 's3kr3t'
  @user = User.create!({
    email: @email,
    password: @password,
    password_confirmation: @password,
    role: 'general'
  })
  @user.update_attribute(:confirmed_at, Time.now - 3.days)
end

Given(/^I am an authenticated 'Operations' user$/) do
  @email = 'operations@hhs.gov'
  @password = 's3kr3t'
  @user = User.create!({
    email: @email,
    password: @password,
    password_confirmation: @password,
    role: 'operations'
  })
  @user.update_attribute(:confirmed_at, Time.now - 3.days)
end

Then(/^I should see the (.+) dashboard$/) do |dash_type|
  expect(page.current_path).to eq('/dashboards/default')
  expect(page).to have_content("#{dash_type.titleize} Dashboard")
end

Then(/^I should be redirected to the (.+) dashboard$/) do |dash_type|
  step "I should see the #{dash_type} dashboard"
end

Then(/^I should see the capacity page$/) do
  expect(page.current_path).to eq('/admin/capacities')
end

Then(/^I should be redirected to the capacity page$/) do
  step "I should see the capacity page"
end
