class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers, id: :uuid do |t|
      t.string :email
      t.string :confirmation_token
      t.datetime :confirmed_at

      t.timestamps null: false
    end
  end
end
