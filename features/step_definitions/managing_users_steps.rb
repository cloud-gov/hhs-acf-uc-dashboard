Given(/^I am an authenticated 'admin' user$/) do
  @admin = User.new({
    email: 'admin@hhs.gov',
    password: 's3kr3t',
    password_confirmation: 's3kr3t'
  })
  @admin.role = 'admin'
  @admin.save!
end

Given(/^there are user of various types in the system$/) do
  password = 'password'

  @users = [
    User.create!({email: 'user-1@hhs.gov', password: password, password_confirmation: password}),
    User.create!({email: 'user-2@hhs.gov', password: password, password_confirmation: password}),
    User.create!({email: 'user-3@hhs.gov', password: password, password_confirmation: password})
  ]

  @users.first.update_attribute(:role, 'leadership')
  @users.last.update_attribute(:role, 'observer')
end

When(/^I visit the 'Users' page$/) do
  visit "/admin/users"
end

Then(/^I should see a list of existing users$/) do
  @users.each do |user|
    expect(page).to have_content(user.email)
  end
end
