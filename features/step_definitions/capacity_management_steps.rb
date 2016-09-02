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
