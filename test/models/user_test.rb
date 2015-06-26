require 'test_helper'


class UserTest < ActiveSupport::TestCase
	setup do
	    @user = users(:one)
	end

	test "get if users is approved or not" do
	assert_equal User.get_approved(@user.id), @user.approved
	end

	test "should destroy user" do
		assert User.destroy_user(@user.id)
	end

	test "should get surname" do
		assert_equal User.get_surname(@user.id), @user.surname
	end

	test "should get name" do
		assert_equal User.get_name(@user.id), @user.name
	end

	test "should get email" do
		assert_equal User.get_email(@user.id), @user.email
	end

	test "should get user" do
		assert_equal User.get_user(@user.id), @user
	end

	test "should get all unapproved users" do
		assert_equal User.unapproved_users.count, 0
	end

	test "should get all approved users" do
		assert_equal User.approved_users.count, 2
	end

	test "should approve user" do
		@user.approved = false
		assert User.approved(@user.id)
	end

	test "should get user reminder setup" do
		assert_equal User.reminder(@user.id), @user.reminder
	end
end
