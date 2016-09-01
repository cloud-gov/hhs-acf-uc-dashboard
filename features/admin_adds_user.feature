Feature:
  As an admin
  I want to add a new user
  So that they are available to participate in the program

  Scenario: Navigating to the 'Add user' page
    Given I have signed in as an authenticated 'Admin' user
    And I visit the 'Users' page
    And I click on the 'Add new user' button
    Then I should be taken to the 'Add user' page

    # rolls in error testing
    When I click the 'Create user' button
    Then I will see an error message about not saving the new user

    # tests cancel buttor
    When I click cancel
    Then I should be taken to the 'Users' page

    # happy path
    When I click on the 'Add new user' button
    And I enter an email address
    And I enter a role for the new user
    And I click the 'Create user' button
    Then I should be returned to the 'User' page
    And I should see with a success message about the added user
    And the newly added user should appear in the list
    And the newly added user should have the correct role
    And the newly added user should be sent an email

  Scenario: Invited user receives email notification
    Given I am an invited user whose account was created by an admin
    And I visit the change password link from my email
    When I fill in a new password and password confirmation
    And I click save
    Then I will be signed in on my home page
