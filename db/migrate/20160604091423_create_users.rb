class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, id: :uuid do |t|
      t.string :email
      t.string :password_digest

      t.timestamps null: false
    end
    add_index :users, :email
  end
end
