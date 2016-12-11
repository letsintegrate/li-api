namespace :db do
  desc 'Update the database views'
  task :update_views => :environment  do
    puts "* Re-creating offer_items view ... "
    select = Offer.select('
      "offer_times"."id" AS id,
      "locations"."id" AS location_id,
      "offers"."id" AS offer_id,
      "offer_times"."id" AS offer_time_id,
      "locations"."name" AS name,
      "offer_times"."time" AS time,
      "locations"."region_id" AS region_id
    ').joins(:locations, :offer_times)
    .confirmed
    .not_canceled
    .not_taken
    .upcoming
    .where(locations: { active: true })
    .to_sql

    sql = "CREATE OR REPLACE VIEW offer_items AS #{select}"
    puts sql

    ActiveRecord::Base.connection.execute(sql)
    puts "done"
  end
end

Rake::Task["db:migrate"].enhance do
  Rake::Task["db:update_views"].invoke
end
