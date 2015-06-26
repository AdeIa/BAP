Feature: Viewer signs up for the newsletter
  In order to sign up
  As a viewer
  I want to be able to sign up into application
 
  Scenario: View form page
    Given I am on "/"
    And I click "Registrovat"
    Then I should see "Registrovat" button

  Scenario: Successful fill out sign up form
    Given I am on "/"
    And I click "Registrovat"
    When I fill in "user[name]" with "Jan"
    When I fill in "user[surname]" with "Novák"
    And I fill in "user[email]" with "jan@novak.cz"
    And I fill in "user[password]" with "heslo123"
    And I fill in "user[password_confirmation]" with "heslo123"

    And I click "Registrovat"
    Then I should see "Vaše registrace byla úspěšná, Váš účet ale zatím nebyl schválen knihovníkem."
    And "jan@novak.cz" receives an email with "Pokyny pro potvrzeni" as the subject
    And "spravce@knihovny.cz" receives an email with "Do aplikace se zaregistroval novy ctenar" as the subject

    When I have logged in as admin
    And I click "Čtenáři"
    And I click on link "jan@novak.cz"
    Then "jan@novak.cz" receives an email with "Schvaleni registrace" as the subject 

  Scenario: Failed fill out sign up form - wrong email
    Given I am on "/"
    And I click "Registrovat"
    When I fill in "user[name]" with "Jan"
    When I fill in "user[surname]" with "Novák"
    And I fill in "user[email]" with "spatny_email"
    And I fill in "user[password]" with "heslo123"
    And I fill in "user[password_confirmation]" with "heslo123"

    And I click "Registrovat"
    Then I should see "Email není validní."


  Scenario: Failed fill out sign up form - too short password
    Given I am on "/"
    And I click "Registrovat"
    When I fill in "user[name]" with "Jan"
    When I fill in "user[surname]" with "Novák"
    And I fill in "user[email]" with "jan@novak.cz"
    And I fill in "user[password]" with "kratke"
    And I fill in "user[password_confirmation]" with "kratke"

    And I click "Registrovat"
    Then I should see "Heslo je příliš krátké(musí obsahovat alespoň 8 znaků)"

  Scenario: Failed fill out sign up form - wrong password confirmation
    Given I am on "/"
    And I click "Registrovat"
    When I fill in "user[name]" with "Jan"
    When I fill in "user[surname]" with "Novák"
    And I fill in "user[email]" with "jan@novak.cz"
    And I fill in "user[password]" with "heslo123"
    And I fill in "user[password_confirmation]" with "spatne_zopakovane_heslo"

    And I click "Registrovat"
    Then I should see "Potvrzení hesla se neshoduje."
