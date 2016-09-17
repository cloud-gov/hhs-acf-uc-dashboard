Given(/^I am a verified 'Admin' user$/) do
  @email = 'admin@hhs.gov'
  @password = 's3kr3t111'
  @admin = User.create!({
    email: @email,
    password: @password,
    password_confirmation: @password,
    role: 'admin'
  })
  @admin.update_attribute(:confirmed_at, Time.now - 3.days)
end

Given(/^I am a verified 'General' user$/) do
  @email = 'general@hhs.gov'
  @password = 's3kr3t111'
  @user = User.create!({
    email: @email,
    password: @password,
    password_confirmation: @password,
    role: 'general'
  })
  @user.update_attribute(:confirmed_at, Time.now - 3.days)
end

Given(/^I am a verified 'Operations' user$/) do
  @email = 'operations@hhs.gov'
  @password = 's3kr3t111'
  @user = User.create!({
    email: @email,
    password: @password,
    password_confirmation: @password,
    role: 'operations'
  })
  @user.update_attribute(:confirmed_at, Time.now - 3.days)
end

Given(/^I am a verified 'No access' user$/) do
  @email = 'no-access@hhs.gov'
  @password = 's3kr3t111'
  @user = User.create!({
    email: @email,
    password: @password,
    password_confirmation: @password
  })
  @user.update_attribute(:confirmed_at, Time.now - 3.days)
end

