require 'rails_helper'

RSpec.describe Location, type: :model do
  subject { FactoryGirl.build :location }

  # Relationships
  #
  it { should have_many(:offers).through(:offer_locations) }

  # Attributes
  #
  it { should have_db_column(:id).of_type :uuid }
  it { should have_db_column(:name).of_type :string }
  it { should have_db_column(:images).of_type :string }
  it { should have_db_column(:slug).of_type :string }
  it { should have_db_column(:special).of_type :boolean }

  # Translated attributes
  #
  it { should respond_to :description }
  it { should respond_to :description= }
  it { should respond_to :description_translations }
  it { should respond_to :description_translations= }

  # Validations
  #
  it { should validate_presence_of :name }
  it { should validate_uniqueness_of(:name).case_insensitive }
  it { should validate_presence_of :slug }
  it { should validate_uniqueness_of(:slug).case_insensitive }

  # Scopes
  #
  describe '#active' do
    it 'includes locations marked as active' do
      location = FactoryGirl.create :location
      expect(Location.active).to include location
    end

    it 'excludes inactive locations' do
      location = FactoryGirl.create :location, active: false
      expect(Location.active).to_not include location
    end
  end

  describe '#regular' do
    it 'includes regular locations' do
      location = FactoryGirl.create :location
      expect(Location.regular).to include location
    end

    it 'excludes special locations' do
      location = FactoryGirl.create :location, special: true
      expect(Location.regular).to_not include location
    end
  end

  # Ransack
  describe '#ransackable_scopes' do
    subject { Location.ransackable_scopes }

    it { should include :regular }
    it { should_not include :active }
  end

  # Methods
  describe '#description_translations' do
    it 'sets all locale keys if a hash is given' do
      subject.description_translations = {
        de: 'hallo',
        en: 'hello'
      }
      I18n.with_locale(:de) { expect(subject.description).to eql('hallo') }
      I18n.with_locale(:en) { expect(subject.description).to eql('hello') }
    end
  end
end
