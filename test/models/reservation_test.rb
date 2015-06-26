require 'test_helper'

class ReservationTest < ActiveSupport::TestCase
	setup do
		@reserved_book = books(:two)
		@book = books(:one)
		@user = users(:two)
		@reservation = reservations(:one)
	end

	test "should not save reservation without user" do
  		reservation = Reservation.new
  		assert_not reservation.save, "Saved the reservation without a user"
	end

	test "should check reservation and return true" do
		assert Reservation.check_user_reservation(@reserved_book.czu_number, @user.id )
	end

	test "should check reservation and return false" do
		assert_not Reservation.check_user_reservation(@book.czu_number, @user.id )
	end

	test "should return that book is reserved" do
		assert Reservation.check_book_reservation(@reserved_book.czu_number )
	end

	test "should return that book is not reserved" do
		assert_not Reservation.check_book_reservation(@book.czu_number)
	end

	test "should return all reservation of book" do
		assert_equal Reservation.get_all_book_reservations(@reserved_book.czu_number).count, 1
		assert_equal Reservation.get_all_book_reservations(@reserved_book.czu_number)[0], @reservation
	end

	test "should return all users who have reservation on the book" do 
		assert_equal Reservation.get_user_id(@reserved_book).count, 1
		assert_equal Reservation.get_user_id(@reserved_book)[0], @user.id
	end

	test "should return all user's reservations" do 
		assert_equal Reservation.get_users_reservations(@user.id).count, 1
		assert_equal Reservation.get_users_reservations(@user.id)[0], @reservation
	end

end
