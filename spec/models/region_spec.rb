require 'rails_helper'

RSpec.describe Region, type: :model do
  subject { FactoryGirl.build :region }

  let(:location)   { FactoryGirl.build :location }

  # Relationships
  #
  it { should have_many(:locations) }

  # Attributes
  #
  it { should have_db_column(:id).of_type :uuid }
  it { should have_db_column(:name).of_type :string }
  it { should have_db_column(:slug).of_type :string }
  it { should have_db_column(:country).of_type :string }
  it { should have_db_column(:sender_email).of_type :string }
  it { should have_db_column(:active).of_type :boolean }

  # Validations
  #
  it { should validate_presence_of :name }
  it { should validate_presence_of :slug }
  it { should validate_uniqueness_of(:slug).case_insensitive }
  it { should validate_presence_of :country }
  it { should validate_presence_of :sender_email }

  # Scopes
  #
  describe '#active' do
    it 'includes regions marked as active' do
      region = FactoryGirl.create :region
      expect(Region.active).to include region
    end

    it 'excludes inactive regions' do
      region = FactoryGirl.create :region, active: false
      expect(Region.active).to_not include region
    end
  end
end
