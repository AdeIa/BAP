class AddReminderToAdmins < ActiveRecord::Migration
  def self.up
  	add_column :admins, :reminder, :boolean
  end
end
