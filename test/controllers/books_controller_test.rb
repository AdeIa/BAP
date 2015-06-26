require 'test_helper'

class BooksControllerTest < ActionController::TestCase
	setup do
    	@admin = admins(:one)
	    @book  = books(:two)
	    @book2  = books(:one)
  	end
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should add kii number" do
    sign_in @admin
  	put :add_registration_number, :id => @book.czu_number, :number => 10
  	@book.reload
  	assert_equal "10", @book.kii_number
    assert_redirected_to books_detail_path, :id => @book.czu_number
    assert_equal 'Evidenční číslo bylo úspěšně přidáno.', flash[:notice]    
  end

  test "should update multiple book with kii number" do
    sign_in @admin
  	put :update_multiple, :books => {@book.czu_number => 10, @book2 => 11}
  	@book.reload
  	@book2.reload
  	assert_equal "10", @book.kii_number
  	assert_equal "11", @book2.kii_number
    assert_redirected_to books_path
    assert_equal 'Editace proběhla úspěšně.', flash[:notice]    
  end

  test "should not open the form without selected books" do
    sign_in @admin
  	post :edit_multiple
    assert_equal 'Nebyla vybrána žádná kniha pro editaci.', flash[:error]
  end
  
end
