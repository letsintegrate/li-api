class CreateOfferItemsView < ActiveRecord::Migration
  def up
    select = Offer.select('
      uuid_generate_v4() AS id,
      "locations"."id" AS location_id,
      "offers"."id" AS offer_id,
      "offer_times"."id" AS offer_time_id,
      "locations"."name" AS name,
      "offer_times"."time" AS time
    ').joins(:locations, :offer_times)
    .confirmed
    .not_canceled
    .not_taken
    .upcoming
    .to_sql

    ActiveRecord::Base.connection.execute(
      "CREATE OR REPLACE VIEW offer_items AS #{select}"
    )
  end

  def down
    ActiveRecord::Base.connection.execute(
      "DROP VIEW offer_items"
    )
  end
end
