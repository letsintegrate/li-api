require 'rails_helper'

RSpec.describe Widget, type: :model do
  subject { FactoryGirl.build :widget }

  # Relationships
  #
  it { should belong_to(:page) }

  # Attributes
  #
  it { should have_db_column(:global_data).of_type :jsonb }
  it { should have_db_column(:id).of_type :uuid }
  it { should have_db_column(:page_id).of_type :string }
  it { should have_db_column(:type).of_type :string }
  it { should have_db_column(:container_name).of_type :string }

  # Getters/Setters
  #
  it { should respond_to :content }
  it { should respond_to :content= }
  it { should respond_to :data }
  it { should respond_to :data= }
  it { should respond_to :class_names }
  it { should respond_to :class_names= }
end
