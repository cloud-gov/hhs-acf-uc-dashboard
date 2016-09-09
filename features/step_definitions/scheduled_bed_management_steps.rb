Given(/^there are scheduled bed values already entered$/) do
  @bed_schedules = [
    BedSchedule.create(facility_name: 'BCFS', bed_count: 230, scheduled_on: Date.parse('2016-09-30'), current: true),
    BedSchedule.create(facility_name: 'Homestead', bed_count: 64, scheduled_on: Date.parse('2016-10-15'), current: true)
  ]
end

Then(/^I should see a form for each schedule$/) do
  expect(page.all('.bed-schedule-form').count).to eq(@bed_schedules.count)
end

Then(/^I will see that the 'Save' button in each schedule form is disabled$/) do
  all_disabled = page.all('.bed-schedule-form input[type=submit]').all? {|node| node[:disabled] }
  expect(all_disabled).to be(true)
end
