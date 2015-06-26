Feature: Everybody could search data in cataloge
  In order to find book
  As a viewer
  I want to be able to find concrete book by title, author or isbn

  Scenario: Successful find book by full title
  	Given I am on "/"
  	And I select "Titul" for search cateodry
    And I fill in "search" with "3 ds Max 8 :průvodce modelováním a animací /Boris Kulagin ; [překlad Jan Kříž]"
    And I click "Hledat"
    Then I should see "Nalezené výsledky"
    And I should see "000058024"
    And I should see "Kulagin, Boris"

 Scenario: Successful find book by substring of title
	Given I am on "/"
  	And I select "Titul" for search cateodry
    And I fill in "search" with "3 ds Max 8 :průvodce modelováním a animací"
    And I click "Hledat"
    Then I should see "Nalezené výsledky"    
    And I should see "000058024"
    And I should see "Kulagin, Boris"

    When I fill in "search" with "3 ds Max 8"
  	And I click "Hledat"
    Then I should see "Nalezené výsledky"    
    And I should see "000058024"
    And I should see "Kulagin, Boris"

    When I fill in "search" with "průvodce modelováním a animací"
  	And I click "Hledat"
    Then I should see "Nalezené výsledky"    
    And I should see "000058024"
    And I should see "Kulagin, Boris"

	When I fill in "search" with "Boris Kulagin"
  	And I click "Hledat"
    Then I should see "Nalezené výsledky"    
    And I should see "000058024"
    And I should see "Kulagin, Boris"

	When I fill in "search" with "[překlad Jan Kříž]"
  	And I click "Hledat"
    Then I should see "Nalezené výsledky"    
    And I should see "000058024"
    And I should see "Kulagin, Boris"

  Scenario: Successful find book by author
  	Given I am on "/"
  	And I select "Autor" for search cateodry
    And I fill in "search" with "Kulagin, Boris"
    And I click "Hledat"
    Then I should see "3 ds Max 8 : průvodce modelováním a animací / Boris Kulagin"    
    And I should see "000058024"
    And I should see "978-80-251-1463-6 (brož.)"

	When I fill in "search" with "Boris Kulagin"
    And I click "Hledat"
    Then I should see "3 ds Max 8 : průvodce modelováním a animací / Boris Kulagin"    
    And I should see "000058024"
    And I should see "978-80-251-1463-6 (brož.)"

    When I fill in "search" with "Kulagin"
    And I click "Hledat"
    Then I should see "3 ds Max 8 : průvodce modelováním a animací / Boris Kulagin"    
    And I should see "000058024"
    And I should see "978-80-251-1463-6 (brož.)"
    And I should see "Kulagin, Boris"

    When I fill in "search" with "Boris"
    And I click "Hledat"
    Then I should see "3 ds Max 8 : průvodce modelováním a animací / Boris Kulagin"    
    And I should see "000058024"
    And I should see "978-80-251-1463-6 (brož.)"
    And I should see "Kulagin, Boris"

	Scenario: Successful find book by ISBN
	Given I am on "/"
  	And I select "ISBN" for search cateodry
    And I fill in "search" with "978-80-251-1463-6"
    And I click "Hledat"
    Then I should see "3 ds Max 8 : průvodce modelováním a animací / Boris Kulagin"    
    And I should see "000058024"
    And I should see "Kulagin, Boris"
    