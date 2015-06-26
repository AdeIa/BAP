password = "heslo123"
admin_email = "new@admin.com"
user_email = "jan@novak.com"

## Given
Given (/^I am on "([^"]*)"$/ )do |path|
  visit path
end

Given (/^I click on link "([^"]*)"$/) do |name|
 click_link name
end

Given (/^I click on page "([^"]*)"$/) do |name|
  first(:link, name).click
end

Given (/^a valid user$/) do
  @user = User.create!({
             :email => user_email,
             :password => password,
             :password_confirmation => password,
             :confirmed_at => "2015-03-07 12:10:27",
             :approved => true
           })
end

Given (/^an admin$/) do
  @admin = Admin.create!({
             :email => admin_email,
             :password => password,
             :password_confirmation => password
           })
end

Given(/^I have logged in as admin$/) do
  Admin.new(email: admin_email, password: password).save!
  visit '/admins/sign_in'
  fill_in 'admin[email]', with: admin_email
  fill_in 'admin[password]', with: password
  click_button 'Přihlásit'
end

Given(/^I have logged in as user$/) do
  User.new(:email => user_email,
             :password => password,
             :password_confirmation => password,
             :confirmed_at => "2015-03-07 12:10:27",
             :approved => true).save!
  visit '/users/sign_in'
  fill_in 'user[email]', with: user_email
  fill_in 'user[password]', with: password
  click_button 'Přihlásit'
end

Given (/^I click the checkbox "([^"]*)" "([^"]*)"$/) do |book_id1, book_id2|
   find(:css, "#book_ids_[value= '#{book_id1}']").set(true)
   find(:css, "#book_ids_[value= '#{book_id2}']").set(true)
end

##Then
Then (/^I should see "([^"]*)"$/) do |text|
  page.should have_content text
end

Then (/^I should see "([^"]*)" in a link$/ ) do |text|
  page.should have_link text
end

Then( /^I should see "([^"]*)" button$/ )do |name|
  find_button(name).should_not be_nil
end

Then (/^I should not see "(.*?)"$/) do |name|
  page.body.should_not have_content name
end
 
##When

When (/^I fill in "([^"]*)" with "([^"]*)"$/) do |element, text|
  fill_in element, with: text
end
 
When (/^I click "([^"]*)"$/) do |element|
  click_on element
end

When (/^I select user$/) do
  page.select('Alena Nováková', :from => 'loan_user_id')
end

When (/^I select user for reservation$/) do
  page.select('Alena Nováková', :from => 'reservation_user_id')
end

When (/^I select "([^"]*)" for search cateodry$/) do |name|
  page.select(name, :from => 'category')
end
