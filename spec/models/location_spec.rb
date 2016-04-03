require 'rails_helper'

RSpec.describe Location, type: :model do
  subject { FactoryGirl.build :location }

  # Relationships
  it { should have_many(:offers).through(:offer_locations) }

  # Attributes
  it { should have_db_column(:id).of_type :uuid }
  it { should have_db_column(:name).of_type :string }
  it { should have_db_column(:description).of_type :text }
  it { should have_db_column(:images).of_type :string }
  it { should have_db_column(:slug).of_type :string }

  # Validations
  it { should validate_presence_of :name }
  it { should validate_uniqueness_of(:name).case_insensitive }
  it { should validate_presence_of :slug }
  it { should validate_uniqueness_of(:slug).case_insensitive }
end
