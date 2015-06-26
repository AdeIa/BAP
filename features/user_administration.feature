Feature: Admin could management users 
  In order to management user by admin role
  As a admin
  I want to be able to edit user data

  Scenario: View admin_users page
  	Given I have logged in as admin
    Given I am on "/admins/users" 
    Then I should see "Čtenáři"
    And I should see "jan@dvorak.cz"

 Scenario: Successful edit user with id 2
 	Given I have logged in as admin
    Given I am on "/admins/users/2/edit" 
    When I fill in "user[name]" with "Pavel"

    And I click "Potvrdit"
    Then I should see "Editace proběhla úspěšně."

  Scenario: Successful show users loans
 	Given I have logged in as admin
 	Given I am on "/loans/user_all/2"

 	Then I should see "Aktuální výpůjčky čtenáře Jan Dvořák"
 	And I should see "3 ds Max 8 : průvodce modelováním a animací / Boris Kulagin ; [překlad Jan Kříž]"
 	And I should see "Kulagin, Boris"


   
