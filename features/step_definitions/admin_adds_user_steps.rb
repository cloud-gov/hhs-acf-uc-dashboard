Given(/^I click on the 'Add new user' button$/) do
  click_on 'Add new user'
end

Then(/^I should be taken to the 'Add user' page$/) do
  expect(page.current_path).to eq('/admin/users/new')
end

When(/^I enter an email address$/) do
  @new_user_email = 'new@hhs.gov'
  fill_in("Email", with: @new_user_email)
end

When(/^I enter a role for the new user$/) do
  @new_user_role = 'General'
  find('select').find(:option, @new_user_role).select_option
end

When(/^I click the 'Create user' button$/) do
  ActionMailer::Base.deliveries.clear
  click_on('Create user')
end

Then(/^I should be returned to the 'User' page$/) do
  expect(page.current_path).to eq('/admin/users')
end

Then(/^I should see with a success message about the added user$/) do
  expect(page).to have_content("Successfully added #{@new_user_email}.")
end

Then(/^the newly added user should appear in the list$/) do
  @new_user = User.where(email: @new_user_email).first
  expect(find(".user-id-#{@new_user.id}")).to have_text(@new_user_email)
end

Then(/^the newly added user should have the correct role$/) do
  role = find(".user-id-#{@new_user.id} option[selected]").value
  expect(role).to eq(@new_user_role)
end

Then(/^the newly added user should be sent an email$/) do
  expect(ActionMailer::Base.deliveries.count).to eq(1)
  mail = ActionMailer::Base.deliveries.last
  expect(mail.subject).to include('invited')
end

Then(/^I will see an error message about not saving the new user$/) do
  expect(page).to have_content("Email can't be blank")
end

When(/^I click cancel$/) do
  click_on('Cancel')
end

Then(/^I should be taken to the 'Users' page$/) do
  expect(page.current_path).to eq('/admin/users')
end
