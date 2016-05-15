class AddReminderSentToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :reminder_sent, :datetime
    add_index :appointments, :reminder_sent
  end
end
