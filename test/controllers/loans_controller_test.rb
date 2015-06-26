require 'test_helper'

class LoansControllerTest < ActionController::TestCase
  setup do
    @loan = loans(:one)
    @user = users(:one)
    @book  = books(:two)
    @borrowed_book  = books(:one)
    @admin = admins(:one)
    @loan_prolong_time = settings(:loan_prolong_time)
    @loan_time = settings(:loan_time)
  end

 test "should create loan" do
    sign_in @admin
    assert_difference('Loan.count') do
      post :create, loan: { book_id: (@book.czu_number), from: Date.today, to: (Date.today + 30), user_id: @user.id }
    end

    assert_equal 'Výpůjčka byla úspěšně uložena do databáze.', flash[:notice]
  end

  test "should get index" do
    sign_in @admin

    get :index
    assert_response :success
    assert_not_nil assigns(:loans)
  end

  test "should get new" do
    sign_in @admin

    get :new,  id: @book.czu_number
    assert_response :success
  end

  test "should show loan" do
    sign_in @admin

    get :show, book_id: @borrowed_book.czu_number, user_id: @user.id, id: 1
    assert_response :success
  end


  test "should destroy loan" do
    sign_in @admin

    assert_difference('Loan.count', -1) do
      delete :destroy, id: @loan
    end

    assert_redirected_to loans_path
    assert_equal 'Výpůjčka byla úspěšně smazána.', flash[:notice]

  end


  test "should prolong loan" do
    sign_in @admin
    get :prolong, id: @loan.id
    
    assert_equal 'Výpůjčka byla úspěšně prodloužena do ' + (@loan.to + 30).to_s, flash[:notice]

  end

  test "should return loan" do
    sign_in @admin
    get :return_book, id: @loan.id
    
    assert_equal 'Výpůjčka byla úspěšně vrácena.', flash[:notice]

  end

end
