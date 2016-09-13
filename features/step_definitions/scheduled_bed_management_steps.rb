Given(/^I add values to the new scheduled beds form$/) do
  within('#new_bed_schedule') do
    fill_in('bed_schedule_facility_name', with: 'Homestead')
    fill_in('bed_schedule_bed_count', with: '300')
    fill_in('bed_schedule_month', with: '10')
    fill_in('bed_schedule_day', with: '3')
    fill_in('bed_schedule_year', with: '2016')
  end
end

Given(/^I save the new schedule$/) do
  within('#new_bed_schedule') do
    click_on('Save')
  end
end

Then(/^I will see the new facility schedule added as an edit form$/) do
  click_on('Capacity') # to reload
  expect(page.all('.bed-schedule-form').count).to eq(2)
end

Then(/^I will see that the 'Save' button in that schedule is disabled$/) do
  save_button = all('form.bed-schedule-form').first.find('input[type=submit]')
  expect(save_button[:disabled]).to eq(true)
end

When(/^I click on the input values for that schedule$/) do
  all('form.bed-schedule-form').first.find('input[type=number]').click
end

Then(/^I will see that the 'Save' button in that schedule is enabled$/) do
  save_button = all('form.bed-schedule-form').first.find('input[type=submit]')
  expect(save_button[:disabled]).to eq(false)
end

When(/^I change values for the facility's schedule$/) do
  all('form.bed-schedule-form').first.find('input[type=number]').set(333)
end

When(/^I save the schedule$/) do
  all('form.bed-schedule-form').first.find('input[type=submit]').click
end

Then(/^I will see that schedule has been changed$/) do
  click_on('Capacity')
  value = all('form.bed-schedule-form').first.find('input[type=number]')[:value]
  expect(value).to eq('333')
end

When(/^I check the 'Remove' checkbox on that schedule$/) do
  all('form.bed-schedule-form').first.find('label[for=bed_schedule_delete]').click
end

Then(/^I will see that the schedule has been removed$/) do
  click_on 'Capacity'
  expect(all('form.bed-schedule-form').count).to eq(1)
end
