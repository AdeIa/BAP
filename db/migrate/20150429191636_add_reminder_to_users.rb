class AddReminderToUsers < ActiveRecord::Migration
   def self.up
  	add_column :users, :reminder, :boolean
  end
end
