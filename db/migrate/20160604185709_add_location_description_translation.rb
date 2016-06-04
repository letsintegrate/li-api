class AddLocationDescriptionTranslation < ActiveRecord::Migration
  def up
    create_table :location_translations, id: :uuid do |t|
      t.references :location, type: :uuid, null: false, index: false
      t.string :locale, null: false
      t.timestamps null: false
      t.text :description
    end
    add_index :location_translations, :location_id
    add_index :location_translations, :locale
    remove_column :locations, :description
  end

  def down
    drop_table :location_translations
    add_column :locations, :description, :text
  end
end
