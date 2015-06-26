class Reservation < ActiveRecord::Base
	belongs_to :book
	belongs_to :user
	validates_uniqueness_of :book_id, scope: :user_id
	validates_presence_of :user_id

	# return all readers reservations
	def self.get_users_reservations(user_id)
		where(user_id: user_id)
	end

	# check if redear has reservation on the book
	def self.check_user_reservation(book_id, user_id)
		reservations = Reservation.where(user_id: user_id)
		reservations.exists?(:book_id => book_id)
	end

	# check if the book has some reservations
	def self.check_book_reservation(book_id)
		reservations = Reservation.all
		reservations.exists?(:book_id => book_id)
	end

	# return all books reservations
	def self.get_all_book_reservations(book_id)
		where(book_id: book_id)
	end

	# delete users reservation on the book
	def self.check_and_delete_reservation(user_id, book_id)
		user_reservations = Reservation.where(user_id: user_id)
		reservations = user_reservations.where(book_id: book_id)
		if (!reservations.empty?)
			reservations.destroy_all
		end
	end
	
	# return all readers who have reservstion on the book
	def self.get_user_id(book_id)
		users_ids = Array.new
		reservations = Reservation.where(book_id: book_id)
		reservations.each do |r|
			users_ids << r.user_id
		end
		return users_ids
	end
	
end
