require 'rails_helper'

RSpec.describe Image, type: :model do
  subject { FactoryGirl.build :image }

  # Attributes
  #
  it { should have_db_column(:file).of_type :string }
  it { should have_db_column(:id).of_type :uuid }
end
