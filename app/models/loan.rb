class Loan < ActiveRecord::Base
	belongs_to :user
	belongs_to :book
	validates :user_id, :presence =>  { :message => " musí být vyplněno" }

	# return all actual loans
	def self.get_actual_loans
		where(:returned => nil)
	end

	# find loan by id
	def self.get_loan_by_id(id)
		find(id)
	end
	# return all returned loans (history)
	def self.get_loans_history
		where.not(returned: nil)
	end

	# return all users loans
	def self.get_users_loan(user_id)
		Loan.where(user_id: user_id)
	end

	# prolong loan
	def self.prolong(loan, prolong_length, max_loan_length)
		if (loan.to + prolong_length - loan.from) > max_loan_length
			loan.update_to(loan.from + max_loan_length)
			return false
		else 
			loan.update_to( loan.to + prolong_length )
		end
		return true
	end

	# update attribute 'to' in loan
	def update_to(to)
		update_attribute(:to, to)
	end

	# mark the loan as returned 
	def self.return_book(loan)
		if loan.update_attribute(:returned, Date.today)
			return true
		else
			return false
		end
	end

	# return count of actual loans of the book
	def self.check_loan(book_id)
		actual_loans = Loan.where(returned: nil)
		return actual_loans.where(book_id: book_id).count
	end

	# return all users who have borrowed the book
	def self.get_user_id(book_id)
		users_ids = Array.new
		actual_loans = Loan.where(returned: nil)
		loans = actual_loans.where(book_id: book_id)
		loans.each do |l|
			users_ids << l.user_id
		end
		return users_ids
	end

	# check all loans to be returned within 7 days
	def self.check_sending_emails
		loans = Loan.get_actual_loans
		comparison_date = Date.today + 8;
		loans = loans.where(to: comparison_date)
		users_id = Array.new

		loans.each do |loan|
			users_id << loan.user_id	
		end

		users_id = users_id.uniq

		books = Array.new
		users_id.each do |user_id|
			users_loans = loans.where(user_id: user_id)
			users_loans.each do |users_loan|
				book = Book.search_by_czu_number(users_loan.book_id)
				books << book.name.to_s + ", " + book.author_name.to_s
			end
			email = User.get_email(user_id)
			if User.reminder(user_id)
				ApplicationMailer.loan_reminder(email, books).deliver
			end
		end
	end

	# delete too old history of loans from database
	def self.remove_old
		month_count = Setting.get_book_history_time
		old_date = Date.today - (month_count*30)
		Loan.where("returned < ?", old_date).destroy_all
	end
end
