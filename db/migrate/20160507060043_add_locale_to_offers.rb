class AddLocaleToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :locale, :string, limit: 2, default: 'en'
  end
end
