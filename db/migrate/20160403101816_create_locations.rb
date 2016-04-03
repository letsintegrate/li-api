class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations, id: :uuid do |t|
      t.string :name
      t.text :description
      t.string :images, array: true, default: []
      t.string :slug

      t.timestamps null: false
    end
  end
end
