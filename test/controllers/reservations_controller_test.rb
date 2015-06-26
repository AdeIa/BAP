require 'test_helper'
class ReservationsControllerTest < ActionController::TestCase
    include Devise::TestHelpers
  setup do
    @reservation = reservations(:one)
    @admin = admins(:one)
    @user = users(:two)
    @book  = books(:two)
    @book_one  = books(:one)
  end

  test "should get index" do
    sign_in @admin
    get :index
    assert_response :success
    assert_not_nil assigns(:reservations)
  end

  test "should get reservations as user" do
    sign_in @user
    get :user, id: @user.id
    assert_response :success
    assert_not_nil assigns(:reservations)
  end


  test "should get new" do
    sign_in @admin    
    get :new, id: @book.czu_number
    assert_response :success
  end

  test "should create reservation" do
    sign_in @admin
    assert_difference('Reservation.count') do
      post :create, reservation: { book_id: @book_one.czu_number, user_id: @user.id }
    end
    assert_equal "Rezervace byla úspěšně uložena.", flash[:notice]

  end

  test "should not create reservation" do
    sign_in @admin
    post :create, reservation: { book_id: @book.czu_number, user_id: @user.id }
    assert_match "je použit již jiným čtenářem.", flash[:error].to_s

  end

  test "should show reservation" do
    sign_in @admin    
    get :show, book_id: @book.czu_number, user_id: @user.id, id: 1
    assert_response :success
  end


  test "should destroy reservation" do
    sign_in @admin
    assert_difference('Reservation.count', -1) do
      delete :destroy, id: @reservation
    end

  end
end
