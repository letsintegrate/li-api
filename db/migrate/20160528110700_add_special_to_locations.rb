class AddSpecialToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :special, :boolean, default: false
    add_index :locations, :special
  end
end
