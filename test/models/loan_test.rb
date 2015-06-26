require 'test_helper'

class LoanTest < ActiveSupport::TestCase
     setup do
	    @max_loan_time = settings(:max_loan_time)
	    @loan = loans(:one)
	    @returned_loan = loans(:two)
	  end

	test "should not save loan without user" do
  		loan = Loan.new
  		assert_not loan.save, "Saved the loan without a user"
	end

	test "should not prolong loan over max_loan_time" do
  		assert_not loan = Loan.prolong(@loan, 200, 30)
	end

	test "should prolong loan" do
  		assert loan = Loan.prolong(@loan, 30, 90)
	end 

	test "should get all actual loans" do
		assert_equal Loan.get_actual_loans.count, 1
		assert_equal Loan.get_actual_loans[0], @loan
	end

	test "should get all returned loans" do
		assert_equal Loan.get_loans_history.count, 1
		assert_equal Loan.get_loans_history[0], @returned_loan
	end

	test "should return loan by id" do
		assert_equal Loan.get_loan_by_id(@loan.id), @loan
	end

	test "should mark loan as returned" do
		assert Loan.return_book(@loan)
	end

	test "should return count of actual loans of the book" do
		assert_equal Loan.check_loan(@loan.book_id), 1
	end

	test "should return all users who have borrowed the book" do
		assert_equal Loan.get_user_id(@loan.book_id).count, 1
	end
end
