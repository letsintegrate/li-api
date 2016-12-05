class CreateMenuItems < ActiveRecord::Migration
  def change
    create_table :menu_items, id: :uuid do |t|
      t.string :name
      t.references :page, index: true, foreign_key: true, type: :uuid
      t.integer :position

      t.timestamps null: false
    end
    add_index :menu_items, :name
    add_index :menu_items, :position
  end
end
