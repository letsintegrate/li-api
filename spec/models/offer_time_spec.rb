require 'rails_helper'

RSpec.describe OfferTime, type: :model do
  subject { FactoryGirl.build :offer_time }

  # Attributes
  it { should have_db_column(:id).of_type :uuid }
  it { should have_db_column(:offer_id).of_type :uuid }
  it { should have_db_column(:time).of_type :datetime }

  # Relationships
  it { should belong_to :offer }

  # Validations
  it { should validate_presence_of  :offer }
  it { should validate_presence_of  :time }
end
