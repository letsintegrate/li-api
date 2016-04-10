require 'rails_helper'

RSpec.describe Offer, type: :model do
  subject { FactoryGirl.build :offer, :confirmed }

  let(:location) { FactoryGirl.build :location }
  let(:offer_time) { FactoryGirl.build :offer_time }

  # Relationships
  it { should have_many(:locations).through(:offer_locations) }

  # Attributes
  it { should have_db_column(:id).of_type :uuid }
  it { should have_db_column(:email).of_type :string }
  it { should have_db_column(:confirmation_token).of_type :string }
  it { should have_db_column(:confirmed_at).of_type :datetime }
  it { should have_db_column(:cancelation_token).of_type :string }

  # Validations
  it { should validate_presence_of :email }
  it { should allow_value('john@example.com').for(:email) }
  it { should_not allow_value('john.example.com').for(:email) }
  it { should allow_value([location]).for(:locations) }
  it { should_not allow_value([]).for(:locations) }
  it { should allow_value([offer_time]).for(:offer_times) }
  it { should_not allow_value([]).for(:offer_times) }

  # Scopes
  describe '#confirmed' do
    it 'contains confirmed records' do
      FactoryGirl.create_list :offer, 3, :confirmed
      expect(Offer.confirmed.count).to eql(3)
    end

    it 'does not contains unconfirmed records' do
      FactoryGirl.create_list :offer, 3
      expect(Offer.confirmed.count).to eql(0)
    end
  end

  describe '#not_taken' do
    it 'contains offers which are not taken' do
      offer = FactoryGirl.create :offer, :confirmed
      expect(Offer.not_taken).to include offer
    end

    it 'does not contain offers that have shortly be taken but not confirmed' do
      offer = FactoryGirl.create :offer, :confirmed
      appointment = FactoryGirl.create :appointment,
                                       location: offer.locations.first,
                                       offer_time: offer.offer_times.first,
                                       offer: offer
      expect(Offer.not_taken).to_not include offer
    end

    it 'contains offers that where taken over 2 hours ago but not confirmed' do
      offer = FactoryGirl.create :offer, :confirmed
      appointment = FactoryGirl.create :appointment,
                                       location: offer.locations.first,
                                       offer_time: offer.offer_times.first,
                                       offer: offer,
                                       created_at: 3.hours.ago
      expect(Offer.not_taken).to include offer
    end

    it 'dose not contain offers have been taken 2 hours ago and have been confirmed' do
      offer = FactoryGirl.create :offer, :confirmed
      appointment = FactoryGirl.create :appointment, :confirmed,
                                       location: offer.locations.first,
                                       offer_time: offer.offer_times.first,
                                       offer: offer,
                                       created_at: 3.hours.ago
      expect(Offer.not_taken).to_not include offer
    end
  end

  describe '#upcoming' do
    it 'includes upcomming offers' do
      offer = FactoryGirl.create :offer, :confirmed, :upcoming
      expect(Offer.upcoming).to include offer
    end

    it 'excludes pased offers' do
      offer = FactoryGirl.create :offer, :confirmed, :expired
      expect(Offer.upcoming).to_not include offer
    end

    it 'includes offers with upcoming and expired times' do
      offer = FactoryGirl.create :offer, :confirmed, offer_times: [
        FactoryGirl.build(:offer_time, :upcoming, offer: nil),
        FactoryGirl.build(:offer_time, :expired, offer: nil),
      ]
      expect(Offer.upcoming).to include offer
    end
  end

  # Methods
  it { should respond_to(:confirm!).with(1).argument }

  describe '#confirm!' do
    subject { FactoryGirl.build :offer }

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

  describe '#confirmed?' do
    it 'exists' do
      expect(subject).to respond_to(:confirmed?).with(0).arguments
    end

    it 'returns true if the record is confirmed' do
      expect(subject.confirmed?).to be true
    end

    it 'returns false if the record is not confirmed' do
      subject = FactoryGirl.build :offer
      expect(subject.confirmed?).to be false
    end
  end

  # Token generation
  it 'generates a confirmation token on create' do
    subject.save!
    expect(subject.confirmation_token).not_to be_nil
  end

  it 'generates a cancelation token on create' do
    subject.save!
    expect(subject.cancelation_token).not_to be_nil
  end

  # Pending
  pending 'email sending'
end
