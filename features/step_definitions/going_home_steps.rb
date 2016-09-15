Then(/^I should see the the default report for my permissions$/) do
  expect(page.current_path).to eq('/daily_reports/current')
end

Then(/^I should be redirected to the (.+) report$/) do |dash_type|
  step "I should see the the default report for my permissions"
end

Then(/^I should see the capacity page$/) do
  expect(page.current_path).to eq('/admin/capacities/current')
end

Then(/^I should be redirected to the capacity page$/) do
  step "I should see the capacity page"
end
