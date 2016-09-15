Feature:
  As an user with access to reports
  I want to see daily data
  So that I can make important decisions about the program and funding

  Scenario: Viewing daily report when today's daily capacity numbers have been locked
    Given I am a user with permission to view the dashboard
    And capacity numbers have alreday been locked today
    When I visit 'Daily' report page
    Then I should see today's daily report
    # viewing options
    When I open the date selector menu for the daily report
    Then I should see all report dates in the dashboard including today
    # changing the date
    When I select another locked day from the date selector menu
    Then I should be taken to that day's report
