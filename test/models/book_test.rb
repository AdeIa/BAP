require 'test_helper'

class BookTest < ActiveSupport::TestCase
	setup do
	    @book = books(:one)
	end

  	test "save text database into relational database" do
	   assert_difference('Book.count', 3) do
	    assert Book.save_into_database('./test/data/data_from_aleph.xml')
	  end

	  assert_match "The design patterns Smalltalk companion", Book.search_by_czu_number('000063337').name
	  assert_match "OpenLayers cookbook", Book.search_by_czu_number('000063674').name
	  assert_match "Environmental Software Systems", Book.search_by_czu_number('000063285').name
	end

	test "should update kii number" do
	  assert Book.write_data('3',@book.czu_number)
	end

	test "should return title" do
		assert_equal Book.get_name(@book.czu_number), @book.name
	end

	test "should return author" do
		assert_equal Book.get_author(@book.czu_number), @book.author_name
	end

	test "should find book by czu_number" do
		assert_equal Book.search_by_czu_number(@book.czu_number), @book
	end

	
end
