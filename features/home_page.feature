Feature: Viewer visits the Home Page
  In order to read the page
  As a viewer
  I want to see the home page of my app

Scenario: Find the link to the form
  Given I am on "/"
  Then I should see "Registrovat" in a link
  And I should see "Přihlásit" in a link