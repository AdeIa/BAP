class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :set_layout_variables

	def set_layout_variables
		unapproved = User.where(approved: false)
	 	@count_of_unapproved = unapproved.count
	end

	def sort_reservations(column, reservations)
		if column == "user_id"
	      reservations = reservations.includes(:user).order("users.surname " + sort_direction)
	    elsif column == "created_at"
	      reservations = reservations.order(sort_column + " " + sort_direction)
	    elsif column == "author_name"
	      reservations =  reservations.includes(:book).order("books.author_name " + sort_direction)
	    elsif column == "name"
	      reservations =  reservations.includes(:book).order("books.name " + sort_direction)
	    end
	    return reservations
	end


end
