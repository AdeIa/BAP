class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :key
      t.integer :value

      t.timestamps null: false
    end
  end
end
