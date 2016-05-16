class AddCountryCityCoordinates < ActiveRecord::Migration
  def change
    add_column :appointments, :country, :string
    add_column :appointments, :city, :string
    add_column :appointments, :lng, :float
    add_column :appointments, :lat, :float
    add_column :offers, :country, :string
    add_column :offers, :city, :string
    add_column :offers, :lng, :float
    add_column :offers, :lat, :float
  end
end
