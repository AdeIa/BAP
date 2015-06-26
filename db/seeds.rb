# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
require 'marc'

# setup admin account
Admin.create!(
	:id => 1, 
	:email=>'your_email', #setup email
	:password=>'your_password', #setup password
	:password_confirmation => 'your_password', #confirm password
	:name => "name", 
	:surname => "surname")


# don't change
Setting.create!(
	[{:id => 1, :key=>'loan_time',:value=>'30', :name => 'Počet dní vypůjčky'},
		{:id => 2, :key=>'loan_prolong_time',:value=>'30', :name => 'Počet dní pro prodloužení výpůjčky'},
		{:id => 3, :key=>'max_loan_time',:value=>'90', :name => 'Maximální počet dní vypůjčení'},
		{:id => 4, :key=>'books_per_page',:value=>'50', :name => 'Počet výtisků zobrazených na stránku v katalogu'},
		{:id => 5, :key=>'book_history_time',:value=>'12', :name => 'Počet měsíců pro uchování historie'}]
	)


reader = Book.read_data('./data/fond.xml')
	for record in reader
	    Book.create(
	    :czu_number => record.try(:[], '001').value, 
	   :kii_number => record.try(:[], '090').try(:[], 'a'),
	   :quantity => record.try(:[], '090').try(:[], 'b'),
	   :name => record.try(:[], '245').try(:[], 'a').to_s + record.try(:[], '245').try(:[], 'b').to_s + record.try(:[], '245').try(:[], 'c').to_s,
	   :author_name => record.try(:[], '100').try(:[], 'a'),
	   :isbn => record.try(:[], '020').try(:[], 'a'),
	   :edition => record.try(:[], '250').try(:[], 'a'),
	   :publishing => record.try(:[], '260').try(:[], 'a').to_s + record.try(:[], '260').try(:[], 'b').to_s + record.try(:[], '260').try(:[], 'c').to_s,
	   :form => record.try(:[], '655').try(:[], 'a'),
	   :description => record.try(:[], '300').try(:[], 'a').to_s + record.try(:[], '300').try(:[], 'b').to_s + record.try(:[], '300').try(:[], 'c').to_s,
	   :language => record.try(:[], '041').try(:[], 'a'))
	end