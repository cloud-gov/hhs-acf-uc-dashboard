Then(/^I should see the the default report for my permissions$/) do
  expect(page.current_path).to eq('/daily_reports/current')
end

Then(/^I should be redirected to the (.+) report$/) do |report_type|
  expect(page.current_path).to include('/daily_reports/')
  expect(page).to have_content("#{report_type.capitalize} view")
end

Then(/^I should see the (.+) version of the report/) do |report_type|
  expect(page).to have_content("#{report_type} view".upcase)
end

Then(/^I should see the capacity page$/) do
  expect(page.current_path).to eq('/admin/capacities/current')
end

Then(/^I should be redirected to the capacity page$/) do
  step "I should see the capacity page"
end
