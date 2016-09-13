Feature:
  As an admin
  I want to manage scheduled bed numbers
  So that capacity estimations can be calculated based on these beds

  @javascript
  Scenario: Adding, editing and deleting bed schedules for a facility
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

    When I check the 'Remove' checkbox on that schedule
    And I save the schedule
    Then I will see that the schedule has been removed
