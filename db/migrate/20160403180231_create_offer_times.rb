class CreateOfferTimes < ActiveRecord::Migration
  def change
    create_table :offer_times, id: :uuid do |t|
      t.references :offer, index: true, foreign_key: true, type: :uuid
      t.datetime :time

      t.timestamps null: false
    end
  end
end
