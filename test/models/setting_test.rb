require 'test_helper'

class SettingTest < ActiveSupport::TestCase
	setup do
	   @loan_time = settings(:loan_time)
	   @loan_prolong_time = settings(:loan_prolong_time)
	   @max_loan_time = settings(:max_loan_time)
	   @books_per_page = settings(:books_per_page)
	end

	test "should get books_per_page value" do
	   assert_equal Setting.get_books_per_page, @books_per_page.value
	end

	test "should get max_loan_time value" do
	   assert_equal Setting.get_max_loan_time, @max_loan_time.value
	end

	test "should get loan_prolong_time value" do
	   assert_equal Setting.get_loan_prolong_time, @loan_prolong_time.value
	end

	test "should get loan time" do
	   assert_equal Setting.get_loan_time, @loan_time.value
	end
end
