Feature:
  As an unverified user
  I want to sign up to ask for permissions to participate
  So that I can access a high level view of the program

  Scenario: Messaging to unverified users on the home page
    Given I am an unverified user
    When I visit the home page
    Then I should see a link to request access

  @wip
  Scenario: Registering as an unverified user
    Given I am an unverified user
    When I click the link to request access
    And I fill in my email
    And I fill in and confirm a password
    And I click to submit
    Then I should see a message telling me I need to verify my email
    And I receive an email asking me to verify my email address

  @wip
  Scenario: Verifying email as an unverified user
    Given I have requested access to the dashboard
    And I receive an email asking me to verify my email address
    When I click on the verification link in the email
    Then I should see a message that my participation is being reviewed
