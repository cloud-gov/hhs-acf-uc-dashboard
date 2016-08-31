Given(/^I click on an 'Add new user' button$/) do
  click_on 'Add new user'
end

Then(/^I should be taken to the 'Add user' page$/) do
  expect(page.current_path).to eq('/admin/users/new')
end
