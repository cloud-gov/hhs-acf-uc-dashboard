Feature:
  As an admin
  I want to manage the daily capacity values before dashboard reporting
  So that reports are not based on outdated data

  Scenario: Seeing the Capacity page
    Given I have signed in as an authenticated 'Admin' user
    And I visit the home page
    Then I should see a link to the 'Capacity' page in the navigation bar

  Scenario: Hiding the Capacity page
    Given I am an authenticated user that is not an 'admin' user
    And I visit the home page
    Then I should not see a link to the 'Capacity' page in the navigation bar

  @wip
  Scenario: Intake values for beds are pre-populated from yesterday's daily values
    Given I have signed in as an authenticated 'Admin' user
    And no other user has already modified the daily intake values
    When I click on the 'Capacity' link
    Then I should see yesterday's capacity values pre-populated as today's values
    And I will see prompts to verify or approve capacity values
    And there will be no notes in the capacity audit log

  #Scenario: Seeing intake values after they have been modified
    #Given I have signed in as an authenticated 'Admin' user
    #And another user has already modified the daily intake values
    #When I visit the 'Capacity' page
    #Then I will see a capacity audit log noting the change
    ##And I will see the capacity status noted

  #Scenario: Locking capacity values that have been entered
    #Given I have signed in as an authenticated 'Admin' user
    #And I visit the 'Capacity' page
    #And the daily capacity numbers have status "unlocked"
    #When I change the capacity status to locked
    #And I click save
    #Then I will see an audit log with the change
    #And the capacity values can no longer be changed

  #Scenario: Unlocking capacity values that have been entered
    #Given I have signed in as an authenticated 'Admin' user
    #And I visit the 'Capacity' page
    #And the daily capacity numbers have status "locked"
    #When I change the capacity status to unlocked
    #And I click save
    #Then I will see an audit log with the change
    #And the capacity values can be changed
