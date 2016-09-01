Feature:
  As an admin
  I want to add a new user
  So that they are available to participate in the program

  Scenario: Navigating to the 'Add user' page
    Given I have signed in as an authenticated 'Admin' user
    And I visit the 'Users' page
    And I click on an 'Add new user' button
    Then I should be taken to the 'Add user' page

  Scenario: Adding new user
    Given I have signed in as an authenticated 'Admin' user
    And I visit the 'Add user' page
    When I enter an email address
    When I enter a role for the new user
    And I click the 'Create user' button
    Then I should be returned to the 'User' page
    And I should see with a success message about the added user
    And the newly added user should appear in the list
    And the newly added user should have the correct role
    And the newly added user should be sent an email

  #Scenario: Invited user receives email notification
    #Given I am an invited user whose account was created by an admin
    #And I visit the change password link from my email
    #When I fill in a password and password confirmation
    #And I click save
    #And I will be taken to the homepage
    #And I will be able to sign in with my new password

  #Scenario: New user information error
    #Given I am an authenticated 'admin' user
    #And I visit the 'Add user' page
    #And I have not entered a valid email address
    #When I click the 'Save user' button
    #Then I should see an error message indicating the problem.

  #Scenario: New user information error
    #Given I am an authenticated 'admin' user
    #And I visit the 'Add user' page
    #When I click the 'Cancel' link
    #Then I should be returned to the 'Users' page.
