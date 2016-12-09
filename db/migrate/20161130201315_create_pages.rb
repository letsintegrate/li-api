class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages, id: :string do |t|
      t.timestamps null: false
    end

    create_table :page_translations, id: :uuid do |t|
      t.references :page, type: :string, null: false, index: false
      t.string :locale, null: false
      t.timestamps null: false
      t.string :title
      t.text :content
    end
    add_index :page_translations, :page_id
    add_index :page_translations, :locale
  end
end
