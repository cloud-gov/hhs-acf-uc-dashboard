Feature:
  As a admin
  I want to grant role level permissions to users
  So that they can participate in the program at the appropriate level

  @wip
  Scenario: Viewing existing users
    Given I am an authenticated 'admin' user
    And there are user of various types in the system
    When I visit the 'Users' page
    #Then I should see a list of existing users

  #@wip
  #Scenario: Promoting the role of a 'No access' user
    #Given I am an authenticated 'admin' user
    #And there is a 'No access' user listed
    #And I visit the 'Users' page
    #When I click on the role of the 'No access' user
    #And I change it to 'Leadership'
    #And I click to save the role change
    #Then I will see the user now has the updated role

  #@wip
  #Scenario: Demoting the role of a user
    #Given I am an authenticated 'admin' user
    #And there is a user with 'Leadership'
    #And I visit the 'Users' page
    #And I am on the 'Users' page
    #When I click on the role of the 'Leadership' user
    #And I change it to 'No access'
    #And I click to save the role change
    #Then I will see the user now has a 'No access' role

 # need scenarios for demoting 'Observer' or 'Admin' roles, or make sure they are covered in unit tests
