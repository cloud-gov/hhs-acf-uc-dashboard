Feature:
  As an admin
  I want to manage scheduled bed numbers
  So that capacity estimations can be calculated based on these beds

  @wip @javascript
  Scenario: Adding a new bed schedule for a facility
    Given I have signed in as an authenticated 'Admin' user
    And I click on the 'Capacity' link
    And I add values to the new scheduled beds form
    And I save the new schedule
    Then I will see the new facility schedule added as an edit form
    And I will see that the 'Save' button in that schedule is disabled

    When I click on the input values for that schedule
    Then I will see that the 'Save' button in that schedule is enabled

    When I change values for the facility's schedule
    And I save the schedule
    Then I will see that schedule has been changed

  #@javascript
  #Scenario: Activating the schedule form button
    #Given I have signed in as an authenticated 'Admin' user
    #And there are scheduled bed values already entered
    #And I click on the 'Capacity' link
    #When I click on an input field in one of the scheduled bed forms
    #Then I will see that the 'Save' button is activated

  #@javascript
  #Scenario: Editing a scheduled opening
    #Given I have signed in as an authenticated 'Admin' user
    #When I click on the 'Capacity' link
    #And I go to the 'Capacity' page
    #And I go to the 'Scheduled bed capacity' area
    #When I edit the values in a row
    #And click 'save'
    #Then the values will be saved and available to the system for calculations

  #Scenario: Adding disallowed values for scheduled bed count
    #Given I have signed in as an authenticated 'Admin' user
    #Given I am an authenticated 'admin' user
    #And I go to the 'Capacity' page
    #And I go to the 'Scheduled bed capacity' area
    #And I enter anything besides a positive integer
    #And I click 'save' in the Scheduled bed capacity form
    #Then I will receive an error informing me that the values entered are not allowed

  #Scenario: Adding a scheduled opening row
    #Given I have signed in as an authenticated 'Admin' user
    #Given I am an authenticated 'admin' user
    #And I go to the 'Capacity' page
    #And I go to the 'Scheduled bed capacity' area
    #When I click 'Add facility'
    #Then I should see a new row added to the table with empty fields available for me to fill in

  #Scenario: Abandoning adding a new
    #Given I have signed in as an authenticated 'Admin' user
    #Given I am an authenticated 'admin' user
    #And I go to the 'Capacity' page
    #And I go to the 'Scheduled bed capacity' area
    #And I have clicked 'Add facility'
    #When I leave the page without saving new facility data
    #Then nothing should be saved
    #And the row should not appear in the future

  #Scenario: Adding scheduled opening data
    #Given I have signed in as an authenticated 'Admin' user
    #Given I am an authenticated 'admin' user
    #And I go to the 'Capacity' page
    #And I go to the 'Scheduled bed capacity' area
    #And I have clicked 'Add facility'
    #When I enter location name, bed count, and effective date info the add facility fields
    #And I click 'save'
    #Then the values will be saved and available to the system for calculations

  #Scenario: Removing a scheduled opening
    #Given I have signed in as an authenticated 'Admin' user
    #Given I am an authenticated 'admin' user
    #And I go to the 'Capacity' page
    #And I go to the 'Scheduled bed capacity' area
    #When I check the 'remove' checkbox
    #And I click 'save'
    #Then the values will be removed and no longer available to the system for calculations
