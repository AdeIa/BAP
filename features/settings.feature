Feature: Admin could change settings of application
  In order to set up settings
  As a admin
  I want to be able to set up settings

  Scenario: Successful set up time of loans
  	Given I have logged in as admin
  	Given I am on "/settings"
  	Then I should see "Nastavení aplikace"
    And I should see "Zasílat automatické emaily knihovníkovi"
    
    When I fill in "settings[1][value]" with "60"
    And I click "Nastavit"
    Then I should see "Nastavení proběhlo úspěšně."
