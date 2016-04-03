require 'rails_helper'

RSpec.describe Offer, type: :model do
  subject { FactoryGirl.build :offer }

  let(:location) { FactoryGirl.build :location }
  let(:offer_time) { FactoryGirl.build :offer_time }

  # Relationships
  it { should have_many(:locations).through(:offer_locations) }

  # Attributes
  it { should have_db_column(:id).of_type :uuid }
  it { should have_db_column(:email).of_type :string }
  it { should have_db_column(:confirmation_token).of_type :string }
  it { should have_db_column(:confirmed_at).of_type :datetime }

  # Validations
  it { should validate_presence_of :email }
  it { should allow_value('john@example.com').for(:email) }
  it { should_not allow_value('john.example.com').for(:email) }
  it { should allow_value([location]).for(:locations) }
  it { should_not allow_value([]).for(:locations) }
  it { should allow_value([offer_time]).for(:offer_times) }
  it { should_not allow_value([]).for(:offer_times) }

  # Methods
  it { should respond_to(:confirm!).with(1).argument }

  describe '#confirm!' do
    it 'fails with wrong token' do
      expect {
        subject.confirm!('foo')
      }.to raise_error(TokenMissmatch)
    end

    it 'updates confirmation time with matching token' do
      Timecop.freeze(Time.local(2008, 9, 1, 12, 0, 0)) do
        subject.save!
        expect {
          subject.confirm!(subject.confirmation_token)
        }.to change { subject.reload.confirmed_at }.from(nil).to Time.zone.now
      end
    end
  end

  # Token generation
  it 'generates a token on create' do
    subject.save!
    expect(subject.confirmation_token).not_to be_nil
  end

  # Pending
  pending 'email sending'
end
