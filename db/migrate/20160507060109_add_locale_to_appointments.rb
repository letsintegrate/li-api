class AddLocaleToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :locale, :string, limit: 2, default: 'en'
  end
end
