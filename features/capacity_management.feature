Feature:
  As an admin
  I want to manage the daily capacity values before dashboard reporting
  So that reports are not based on outdated data

  Scenario: Hiding the Capacity link from non-admins
    Given I have signed in as an authenticated user that is not an 'admin' user
    Then I should not see a link to the 'Capacity' page in the navigation bar

  Scenario: Viewing and updating capacity record
    Given I have signed in as an authenticated 'Admin' user
    And the API is available
    And no other user has already modified the daily intake values
    When I click on the 'Capacity' link
    Then I should see yesterday's capacity values pre-populated as today's values
    And I should see that the capacity values are for today's date
    And I should see the capacity values are unlocked
    And there will be no notes in the capacity audit log

    When I click on the 'Capacity' link
    And I update intake values
    Then My API cached values will be saved

    When I click on the 'Capacity' link
    Then I will see the capacity values have been modified from yesterday
    Then I will see a capacity audit log noting the change

    When I change the status to locked and save capacity
    Then I will see the capacity form is locked
    And I will see a note about locking the capacity

    When I change the status to unlocked and save capacity
    Then I will see the capacity form is unlocked
    And I will see a note about unlocking the capacity

  Scenario: Saving capacity when the API is down
    Given I have signed in as an authenticated 'Admin' user
    And the API is down
    When I click on the 'Capacity' link
    And I update intake values
    Then I should see an alert that information could not be cached from the API

  Scenario: Viewing the Bed capacity history
    Given I have signed in as an authenticated 'Admin' user
    And there are capacity records in the past
    When I click to view the 'Bed capacity history'
    Then I will see a list of all dates since the first recorded capacity in reverse chronological order
