Then(/^I should see a link to Sign in$/) do
  within('.site-navbar .links') do
    expect(page).to have_link('Sign in')
  end
end

Then(/^I should see a link to Sign out$/) do
  within('.site-navbar .links') do
    expect(page).to have_link('Sign out')
  end
end

Then(/^I should not see a link to a daily report$/) do
  within('.site-navbar .links') do
    expect(page).to_not have_link('Daily')
  end
end

Then(/^I should not see a link to manage users$/) do
  within('.site-navbar .links') do
    expect(page).to_not have_link('Users')
  end
end

When(/^I sign out$/) do
  click_on('Sign out')
end

Then(/^I should see a link to my daily report$/) do
  within('.site-navbar .links') do
    expect(page).to have_link('Daily')
  end
end

Then(/^I should see a link to daily reports$/) do
  within('.site-navbar .links') do
    expect(page).to have_link('Daily')
  end
end

Then(/^I should see a link to manage users$/) do
  within('.site-navbar .links') do
    expect(page).to have_link('Users')
  end
end
