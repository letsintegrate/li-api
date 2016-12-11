require 'rails_helper'

RSpec.describe OfferItem, type: :model do
  let(:offer) { FactoryGirl.create :offer, :confirmed, :upcoming }

  subject { OfferItem.where(offer_id: offer.id).first! }

  # Relationships
  it { should belong_to :region }
  it { should belong_to :location }
  it { should belong_to :offer_time }
  it { should belong_to :offer }

  # Attributes
  it { should have_db_column :id }
  it { should have_db_column :location_id }
  it { should have_db_column :region_id }
  it { should have_db_column :offer_time_id }
  it { should have_db_column :time }
  it { should have_db_column :name }

end
