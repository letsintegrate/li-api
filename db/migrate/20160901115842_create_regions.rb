class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions, id: :uuid do |t|
      t.string :name
      t.string :slug
      t.string :country
      t.string :sender_email
      t.boolean :active, default: true

      t.timestamps null: false
    end

    add_index :regions, :slug, unique: true
  end
end
