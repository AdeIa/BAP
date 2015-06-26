class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books, :id => false do |t|
      t.string :czu_number, primary_key: true
      t.string :kii_number
      t.integer :quantity
      t.string :name, :limit => 512
      t.string :author_name
      t.string :isbn
      t.string :edition
      t.string :publishing
      t.string :form
      t.string :description
      t.string :language

      t.timestamps null: false
    end
  end
end
