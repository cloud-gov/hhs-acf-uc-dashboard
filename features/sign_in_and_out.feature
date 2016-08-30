Feature:
  As an verified user
  I want to sign in and see applicable links
  So I know what I can and can't do within the app

  Scenario: 'No access' users
    Given I am a verified 'No access' user
    When I visit the home page
    Then I should see a link to Sign in
    When I sign in
    Then I should see a link to Sign out
    And I should not see a link to a dashboard
    And I should not see a link to manage users
    When I sign out
    Then I should see a link to Sign in

  Scenario: 'General' users
    Given I am a verified 'General' user
    When I visit the home page
    Then I should see a link to Sign in
    When I sign in
    Then I should see a link to Sign out
    And I should see a link to my dashboard
    And I should not see a link to manage users
    When I sign out
    Then I should see a link to Sign in

  Scenario: 'Operations' users
    Given I am a verified 'Operations' user
    When I visit the home page
    Then I should see a link to Sign in
    When I sign in
    Then I should see a link to Sign out
    And I should see a link to my dashboard
    And I should not see a link to manage users
    When I sign out
    Then I should see a link to Sign in

  Scenario: 'Admin' users
    Given I am a verified 'Admin' user
    When I visit the home page
    Then I should see a link to Sign in
    When I sign in
    Then I should see a link to Sign out
    And I should see a link to dashboards
    And I should see a link to manage users
    When I sign out
    Then I should see a link to Sign in

