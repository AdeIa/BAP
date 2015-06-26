Feature: Viewer signs in
  In order to sign in a application
  As a user
  I want to be able to sign in

 Scenario: View form page
    Given I am on "/users/sign_in"
    Then I should see "Přihlásit" button

Scenario: Successul user sign in
	Given a valid user
    Given I am on "/users/sign_in"
    And I fill in "user[email]" with "jan@novak.com"
    And I fill in "user[password]" with "heslo123"

    And I click "Přihlásit"
    Then I should see "Přihlášení proběhlo úspěšně."

Scenario: Failed user sign in
	Given a valid user
    Given I am on "/users/sign_in"
    And I fill in "user[email]" with "jan@novak.com"
    And I fill in "user[password]" with "spatne_heslo"

    And I click "Přihlásit"
    Then I should see "Neplatný email nebo heslo."