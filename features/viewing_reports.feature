Feature:
  As an user with access to reports
  I want to see daily data
  So that I can make important decisions about the program and funding

  Scenario: Viewing daily report when today's daily capacity numbers are unlocked
    Given I am a user with permission to view the dashboard
    And capacity numbers were locked yesterday, but not today
    When I visit 'Daily' report page
    Then I should see yesterday's daily report
