class CreateLoans < ActiveRecord::Migration
  def change
    create_table :loans do |t|
      t.string :book_id
      t.integer :user_id
      t.date :from
      t.date :to
      t.date :returned

      t.timestamps null: false
    end
  end
end
