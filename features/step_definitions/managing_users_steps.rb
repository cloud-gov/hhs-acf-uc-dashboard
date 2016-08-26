Given(/^I have signed in as an authenticated 'admin' user$/) do
  step "I am an authenticated 'admin' user"
  step "I visit the home page"
  step "I sign in"
end

Given(/^I am an authenticated 'admin' user$/) do
  @email = 'admin@hhs.gov'
  @password = 's3kr3t'
  @admin = User.create!({
    email: @email,
    password: @password,
    password_confirmation: @password,
    role: 'admin'
  })
  @admin.update_attribute(:confirmed_at, Time.now - 3.days)
end

Given(/^there are user of various types in the system$/) do
  password = 'password'

  @users = [
    User.create!({email: 'user-1@hhs.gov', password: password, password_confirmation: password}),
    User.create!({email: 'user-2@hhs.gov', password: password, password_confirmation: password}),
    User.create!({email: 'user-3@hhs.gov', password: password, password_confirmation: password})
  ]

  @users.first.update_attribute(:role, 'operations')
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

Given(/^there is a 'No access' user listed$/) do
  step "there are user of various types in the system"
  @no_access_user = @users[1]
end

When(/^I change the role of the 'No access' user to 'Operations'$/) do
  within("form.user_id_#{@no_access_user.id}") do
    find('input[name=role]').click
    fill_in('role', with: 'Operations')
  end
end

When(/^I click to save the role change$/) do
  within("form.user_id_#{@no_access_user.id}") do
    click_button('Save')
  end
end

Then(/^I will see the role of the 'No access' user is now 'Operations'$/) do
  within("form.user_id_#{@no_access_user.id}") do
    new_role = find('select[name=role]').value
    expect(new_role).to eq('Operations')
  end
end
