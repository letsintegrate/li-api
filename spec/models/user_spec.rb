require 'rails_helper'

RSpec.describe User, type: :model do
  subject { FactoryGirl.build :user }

  # Attributes
  it { should have_db_column(:id).of_type :uuid }
  it { should have_db_column(:email).of_type :string }
  it { should have_db_column(:password_digest).of_type :string }

  # Validations
  it { should validate_presence_of :email }
  it { should validate_uniqueness_of(:email).case_insensitive }
end
