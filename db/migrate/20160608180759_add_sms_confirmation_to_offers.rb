class AddSmsConfirmationToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :phone, :string
    add_column :locations, :phone_required, :boolean
  end
end
