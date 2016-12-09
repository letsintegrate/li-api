require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  subject { FactoryGirl.build :menu_item }

  # Relationships
  #
  it { should belong_to(:page) }

  # Attributes
  #
  it { should have_db_column(:id).of_type :uuid }
  it { should have_db_column(:name).of_type :string }
  it { should have_db_column(:page_id).of_type :string }

  # Validations
  #
  it { should validate_presence_of :name }
  it { should validate_presence_of :page }
end
