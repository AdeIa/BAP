class Setting < ActiveRecord::Base

	def self.get_loan_time
		find_by(key: "loan_time").value
	end

	def self.get_loan_prolong_time
		find_by(key: "loan_prolong_time").value
	end

	def self.get_books_per_page
		find_by(key: "books_per_page").value
	end

	def self.get_max_loan_time
		find_by(key: "max_loan_time").value
	end

	def self.get_book_history_time
		find_by(key: "book_history_time").value
	end

end
