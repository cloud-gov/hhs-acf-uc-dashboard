Feature:
  As a user with some level of access to dashboard(s)
  I want to visit the home page while logged in and see my dashboard permissions
  So that I know how I fit into the application permissions

  Scenario: General users auto travel to their dashboard
    Given I am an authenticated 'General' user
    And I visit the home page
    When I sign in
    Then I should see the general dashboard

    When I visit the home page
    Then I should be redirected to the general dashboard

  Scenario: Operations users auto travel to their dashboard
    Given I am an authenticated 'Operations' user
    And I visit the home page
    When I sign in
    Then I should see the operations dashboard

    When I visit the home page
    Then I should be redirected to the operations dashboard

  Scenario: Admin users auto travel to capacity management
    Given I am an authenticated 'admin' user
    And I visit the home page
    When I sign in
    Then I should see the capacity page

    When I visit the home page
    Then I should be redirected to the capacity page
