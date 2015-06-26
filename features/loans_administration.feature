Feature: Admin could management loans
  In order to management loans
  As a admin
  I want to be able to management users loans

  Scenario: View loans form
  	Given I have logged in as admin
    Given I am on "/loans/user_all/2" 
    And I click on link "loan_000058024"
    Then I should see "Vypůjčit knihu jinému čtenáři"
    And I should see "3 ds Max 8 : průvodce modelováním a animací / Boris Kulagin ; [překlad Jan Kříž]"

  Scenario: Successful fill out loans form for another user
  	Given I have logged in as admin
    Given I am on "/loans/user_all/2" 
    And I click on link "loan_000058024"
    
    When I select user
    And I click "Vypůjčit"
    Then I should see "Výpůjčka byla úspěšně uložena do databáze."

    Given I am on "/loans/user_all/3" 
    Then I should see "3 ds Max 8 : průvodce modelováním a animací / Boris Kulagin ; [překlad Jan Kříž]"

    Given I am on "/loans/user_all/2" 
    Then I should see "Čtenář nemá momentálně žádné výpůjčky."


  Scenario: Failed fill out loans form - no select another user
  	Given I have logged in as admin
    Given I am on "/loans/user_all/2" 
    And I click on link "loan_000058024"

    And I click "Vypůjčit"
    Then I should see "Čtenář musí být vyplněn"

  Scenario: Successful prolong loan of user
  	Given I have logged in as admin
    Given I am on "/loans/user_all/2" 
    Then I click on link "prolong_000058024"

    Then I should see "Výpůjčka byla úspěšně prodloužena do 2015-07-06"

  Scenario: Prolong loan of user only to max date
  	Given I have logged in as admin
  	Given I am on "/loans/user_all/2" 
    Then I click on link "prolong_000058024"
    Given I am on "/loans/user_all/2" 
    Then I click on link "prolong_000058024"
    Given I am on "/loans/user_all/2" 
    Then I click on link "prolong_000058024"

    Then I should see "Výpůjčku lze prodloužit nejdéle do 2015-08-04"

  Scenario: Successful return loan of user
  	Given I have logged in as admin
    Given I am on "/loans/user_all/2" 
    Then I click on link "delete_000058024"
    
    Then I should see "Výpůjčka byla úspěšně vrácena."

  Scenario: Successful loan book 
    Given I have logged in as admin
    Given I click on link "Katalog knih" 
    And I click on link "BPMN method and style /Bruce Silver"
    Then I should see "BPMN method and style /Bruce Silver"
    And I should see "Dostupnost Kniha je rezervovaná"
    And I should see "Počet jednotek  2/2"
    And I should see "Rezervovat"
    And I should see "Vypůjčit"

    When I click "Vypůjčit"
    Then I should see "Nová výpůjčka"
    And I should see "BPMN method and style /Bruce Silver"

    When I select user
    And I click "Vypůjčit"
    Then I should see "Výpůjčka byla úspěšně uložena do databáze."

    Given I click on link "Katalog knih" 
    And I click on link "BPMN method and style /Bruce Silver"
    Then I should see "Počet jednotek  1/2"

    When I click on link "Katalog knih" 
    And I click on link "Agile Software Development with Scrum /Ken Schwaber, Mike Beedle"
    When I click "Vypůjčit"
    And I select user
    And I click "Vypůjčit"
    Then I should see "Výpůjčka byla úspěšně uložena do databáze."

    Given I click on link "Katalog knih" 
    And I click on link "Agile Software Development with Scrum /Ken Schwaber, Mike Beedle"
    Then I should not see "Vypůjčit"
    And I should see "Počet jednotek  0/1"
    And I should see "Dostupnost  Vypůjčená čtenářem Nováková Alena"

    Given I am on "/loans/user_all/3" 
    Then I should see "BPMN method and style /Bruce Silver"
    And I should see "Agile Software Development with Scrum /Ken Schwaber, Mike Beedle"

  Scenario: Failed loan book 
    Given I have logged in as admin
    Given I click on link "Katalog knih"  
    And I click on link "BPMN method and style /Bruce Silver"
    And I click "Vypůjčit"

    Then I should see "Nová výpůjčka"
    And I should see "BPMN method and style /Bruce Silver"

    When I click "Vypůjčit"
    Then I should see "Čtenář musí být vyplněn"

    Given I am on "/loans/user_all/3" 
    Then I should see "Čtenář nemá momentálně žádné výpůjčky."
