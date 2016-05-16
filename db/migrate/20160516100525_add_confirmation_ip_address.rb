class AddConfirmationIpAddress < ActiveRecord::Migration
  def change
    add_column :appointments, :confirmation_ip_address, :inet
    add_column :offers, :confirmation_ip_address, :inet
  end
end
