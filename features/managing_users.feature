Feature:
  As a admin
  I want to grant role level permissions to users
  So that they can participate in the program at the appropriate level

  Scenario: Viewing existing users
    Given I have signed in as an authenticated 'admin' user
    And there are user of various types in the system
    When I visit the 'Users' page
    Then I should see a list of existing users

  @javascript
  Scenario: Promoting the role of a 'No access' user
    Given I have signed in as an authenticated 'admin' user
    And there is a 'No access' user listed
    And I visit the 'Users' page
    When I change the role of the 'No access' user to 'Operations'
    And I click to save the role change
    Then I will see the role of the 'No access' user is now 'Operations'

  @javascript
  Scenario: Demoting the role of a user
    Given I have signed in as an authenticated 'admin' user
    And there is a 'Operations' user listed
    And I visit the 'Users' page
    When I change the role of the 'Operations' user to 'No access'
    And I click to save the role change
    Then I will see the role of the 'Operations' user is now 'No access'
