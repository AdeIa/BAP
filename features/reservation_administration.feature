Feature: Admin could management reservations
  In order to management reservation
  As a admin
  I want to be able to management users reservations

  Scenario: Successful loan book as admin
  	Given I have logged in as admin
    When I click on link "Rezervace"
  	Then I should see "BPMN method and style /Bruce Silver Silver"

    When I click on link "Katalog knih"
    And I click on link "Agile Software Development with Scrum /Ken Schwaber, Mike Beedle"
   	And I click "Rezervovat"
    Then I should see "Nová rezervace"
    And I should see "Agile Software Development with Scrum /Ken Schwaber, Mike Beedle"

    When I select user for reservation
    And I click "Rezervovat"
    Then I should see "Rezervace byla úspěšně uložena."

    When I click on link "Rezervace"
    Then I should see "Nováková Alena"
    And I should see "Agile Software Development with Scrum /Ken Schwaber, Mike Beedle"