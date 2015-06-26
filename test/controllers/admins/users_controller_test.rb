require 'test_helper'

class Admins::UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:two)
    @admin = admins(:one)
  end

  test "should destroy user" do
    sign_in @admin
	
	assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end  	

    assert_redirected_to admins_users_path
    assert_equal 'Uživatel byl úspěšně odstraněn.', flash[:notice]
  end

  test "should update user" do
    sign_in @admin
    put :update, :id => @user.id, :user => {:name => "Katka"}  
    @user.reload
    assert_equal @user.name, "Katka"
    assert_equal 'Editace proběhla úspěšně.', flash[:notice]    
  end

  test "should approved user" do
    sign_in @admin
    @user.approved = false
    get :approved, :id => @user.id
    @user.reload
    assert_equal @user.approved, true
  end

end
