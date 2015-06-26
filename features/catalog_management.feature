Feature: Admin could management cataloge
  In order to management cataloge
  As a admin
  I want to be able to management cataloge

  Scenario: View catalog as admin
  	Given I have logged in as admin
    When I click "Katalog knih"
    Then I should see "Databáze knih"
    And I should see "Přidat evidenční čísla" button
    And I should see "3 ds Max 8"

  Scenario: Failed click on button
  	Given I have logged in as admin
    When I click "Katalog knih"
    And I click "Přidat evidenční čísla"
    Then I should see "Nebyla vybrána žádná kniha pro editaci."

  Scenario: Open cataloge, select books and edit their number
   	Given I have logged in as admin
    When I click "Katalog knih" 
  	And I click the checkbox "000058024" "000058159"
    And I click "Přidat evidenční čísla"
   
    Then I should see "Přidání evidenčního čísla"
    And I should see "3 ds Max 8 : průvodce modelováním a animací / Boris Kulagin ; [překlad Jan Kříž]"
    And I should see "BPMN method and style /Bruce Silver"
    
    Then I fill in "books[000058024]" with "1"
    And I fill in "books[000058159]" with "2"
    And I click "Odeslat"

    Then I should see "Editace proběhla úspěšně."

    Given I click on link "3 ds Max 8 : průvodce modelováním a animací / Boris Kulagin ; [překlad Jan Kříž]"
    Then I should see "Evidenční číslo 	1"

    Given I am on "/books/detail/000058159" 
    Then I should see "Evidenční číslo 	2"
    Then I fill in "number" with "3"
    And I click "Editovat"
	Then I should see "Evidenční číslo bylo úspěšně přidáno."
	And I should see "Evidenční číslo 	3"
	And I should not see "Evidenční číslo 	2"
