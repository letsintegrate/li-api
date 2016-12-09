require 'rails_helper'

RSpec.describe Page, type: :model do
  let(:page) { FactoryGirl.build :page }

  subject { page }

  # Attributes
  #
  it { should have_db_column(:id).of_type :string }

  # Relationships
  #
  it { should have_many(:menu_items) }
  it { should have_many(:widgets) }

  # Translated attributes
  #
  it { should respond_to :title }
  it { should respond_to :title= }
  it { should respond_to :title_translations }
  it { should respond_to :title_translations= }
  it { should respond_to :content }
  it { should respond_to :content= }
  it { should respond_to :content_translations }
  it { should respond_to :content_translations= }

  # Validations
  #
  it { should validate_presence_of :id }
  it { should validate_uniqueness_of(:id).case_insensitive }

  # Methods
  #
  describe '#title_translations' do
    it 'sets all locale keys if a hash is given' do
      subject.title_translations = {
        de: 'hallo',
        en: 'hello'
      }
      I18n.with_locale(:de) { expect(subject.title).to eql('hallo') }
      I18n.with_locale(:en) { expect(subject.title).to eql('hello') }
    end
  end

  describe '#content_translations' do
    it 'sets all locale keys if a hash is given' do
      subject.content_translations = {
        de: 'hallo',
        en: 'hello'
      }
      I18n.with_locale(:de) { expect(subject.content).to eql('hallo') }
      I18n.with_locale(:en) { expect(subject.content).to eql('hello') }
    end
  end
end
