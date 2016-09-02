class AttachLocationsToRegions < ActiveRecord::Migration
  def change
    region = Region.find_or_create_by(slug: 'berlin') do |region|
      region.name         = 'Berlin'
      region.country      = 'Germany'
      region.sender_email = 'appointments@letsintegrate.de'
    end

    add_column :locations, :region_id, :uuid
    Location.update_all region_id: region.id
    change_column :locations, :region_id, :uuid, null: false
    add_index :locations, :region_id
  end
end
