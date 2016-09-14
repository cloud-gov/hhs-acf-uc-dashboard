Feature:
  As a user with some level of access to report(s)
  I want to visit the home page while logged in and see my report permissions
  So that I know how I fit into the application permissions

  Scenario: General users auto travel to their daily report
    Given I am a verified 'General' user
    And I visit the home page
    When I sign in
    Then I should see the the default report for my permissions

    When I visit the home page
    Then I should be redirected to the general report

  Scenario: Operations users auto travel to their report
    Given I am a verified 'Operations' user
    And I visit the home page
    When I sign in
    Then I should see the the default report for my permissions

    When I visit the home page
    Then I should be redirected to the operations report

  Scenario: Admin users auto travel to capacity management
    Given I am a verified 'Admin' user
    And I visit the home page
    When I sign in
    Then I should see the capacity page

    When I visit the home page
    Then I should be redirected to the capacity page
