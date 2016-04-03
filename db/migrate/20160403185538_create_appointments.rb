class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments, id: :uuid do |t|
      t.references :offer_time, index: true, foreign_key: true, type: :uuid
      t.references :offer, index: true, foreign_key: true, type: :uuid
      t.string :email
      t.string :confirmation_token
      t.datetime :confirmed_at, null: true, default: nil
      t.string :cancelation_token, null: true, default: nil
      t.datetime :canceled_at, null: true, default: nil

      t.timestamps null: false
    end
  end
end
