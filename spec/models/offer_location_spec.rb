require 'rails_helper'

RSpec.describe OfferLocation, type: :model do
  subject { FactoryGirl.build :offer_location }

  # Attributes
  it { should have_db_column(:id).of_type :uuid }
  it { should have_db_column(:location_id).of_type :uuid }
  it { should have_db_column(:offer_id).of_type :uuid }

  # Relationships
  it { should belong_to :location }
  it { should belong_to :offer }

  # Validations
  it { should validate_presence_of  :location }
  it { should validate_presence_of  :offer }
end
