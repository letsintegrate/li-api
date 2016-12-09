class CreateWidgets < ActiveRecord::Migration
  def change
    create_table :widgets, id: :uuid do |t|
      t.string :container_name
      t.string :type
      t.references :page, index: true, foreign_key: true, type: :string
      t.integer :position
      t.jsonb :global_data, default: {}

      t.timestamps null: false
    end
    add_index :widgets, :container_name
    add_index :widgets, :type
    add_index :widgets, :position

    create_table :widget_translations, id: :uuid do |t|
      t.references :widget, type: :uuid, null: false, index: false
      t.string :locale, null: false
      t.timestamps null: false
      t.jsonb :data, default: {}
      t.text :content
    end
    add_index :widget_translations, :widget_id
    add_index :widget_translations, :locale
  end
end
