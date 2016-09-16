Feature:
  As an user with access to reports
  I want to see daily data
  So that I can make important decisions about the program and funding

  @javascript
  Scenario: Viewing daily reports by date
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

  @javascript
  Scenario: Viewing different reports by type as an admin
    Given I have signed in as an authenticated 'Admin' user
    When I visit 'Daily' report page
    Then I should see the operations version of the report

    When I choose General from report type selector
    Then I should see the general version of the report

  @javascript
  Scenario: Viewing reports as a general user
    Given I am a verified 'General' user
    And I visit the home page
    And I sign in
    When I visit 'Daily' report page
    Then I should not see a select for the report type
    And I should see the general version of the report

  @javascript
  Scenario: Viewing reports as a general user
    Given I am a verified 'Operations' user
    And I visit the home page
    And I sign in
    When I visit 'Daily' report page
    Then I should not see a select for the report type
    And I should see the operations version of the report
