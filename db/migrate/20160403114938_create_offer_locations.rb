class CreateOfferLocations < ActiveRecord::Migration
  def change
    create_table :offer_locations, id: :uuid do |t|
      t.references :location, index: true, foreign_key: true, type: :uuid
      t.references :offer, index: true, foreign_key: true, type: :uuid

      t.timestamps null: false
    end
  end
end
