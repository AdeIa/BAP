class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.string :book_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
