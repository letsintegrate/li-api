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
  it { should have_db_column(:canceled_at).of_type :datetime }
  it { should have_db_column(:locale).of_type :string }
  it { should have_db_column(:confirmation_ip_address).of_type :inet }
  it { should have_db_column(:country).of_type :string }
  it { should have_db_column(:city).of_type :string }
  it { should have_db_column(:lat).of_type :float }
  it { should have_db_column(:lng).of_type :float }
  it { should have_db_column(:phone).of_type :string }

  it { should respond_to(:phone_required?) }

  # Validations
  it { should validate_presence_of :email }
  it { should allow_value('john@gmail.com').for(:email) }
  it { should_not allow_value('john.gmail.com').for(:email) }
  it { should allow_value([location]).for(:locations) }
  it { should_not allow_value([]).for(:locations) }
  it { should allow_value([offer_time]).for(:offer_times) }
  it { should_not allow_value([]).for(:offer_times) }

  it 'is valid without a phone number' do
    subject.phone = nil
    expect(subject).to be_valid
  end

  context 'with phone required' do
    subject { FactoryGirl.build :offer, :confirmed, :phone_required }

    it { should allow_value('+4917712345678').for(:phone) }
    it { should_not allow_value('+493012345678').for(:phone) }

    it 'is invalid without a phone number' do
      subject.phone = nil
      expect(subject).to_not be_valid
    end
  end

  # Methods

  describe '#phone_required?' do
    it 'is true if one location requires phone verification' do
      offer = FactoryGirl.build :offer, :confirmed, :phone_required
      expect(offer.phone_required?).to be true
    end

    it 'is false if no location requires phone verification' do
      offer = FactoryGirl.build :offer, :confirmed
      expect(offer.phone_required?).to be false
    end
  end

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
                                       offer: offer
      expect(Offer.not_taken).to_not include offer
    end

    it 'contains offers that where taken over 2 hours ago but not confirmed' do
      offer = FactoryGirl.create :offer, :confirmed
      appointment = FactoryGirl.create :appointment,
                                       offer: offer,
                                       created_at: 3.hours.ago
      expect(Offer.not_taken).to include offer
    end

    it 'dose not contain offers have been taken 2 hours ago and have been confirmed' do
      offer = FactoryGirl.create :offer, :confirmed
      appointment = FactoryGirl.create :appointment, :confirmed,
                                       offer: offer,
                                       created_at: 3.hours.ago
      expect(Offer.not_taken).to_not include offer
    end

    it 'includes offers with canceled appointments' do
      offer = FactoryGirl.create :offer, :confirmed
      appointment = FactoryGirl.create :appointment, :confirmed,
                                       offer: offer,
                                       created_at: 3.hours.ago,
                                       canceled_at: 1.hour.ago
      expect(Offer.not_taken).to include offer
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

  describe '#not_canceled' do
    it 'includes not canceled offers' do
      offer = FactoryGirl.create :offer, :confirmed, :upcoming
      expect(Offer.not_canceled).to include offer
    end

    it 'excludes caneled offers' do
      offer = FactoryGirl.create :offer, :confirmed, :upcoming, :canceled
      expect(Offer.not_canceled).to_not include offer
    end
  end

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

  describe '#cancel!' do
    subject { FactoryGirl.build :offer }

    it 'fails with wrong token' do
      expect {
        subject.cancel!('foo')
      }.to raise_error(TokenMissmatch)
    end

    it 'updates cancelation time with matching token' do
      Timecop.freeze(Time.local(2008, 9, 1, 12, 0, 0)) do
        subject.save!
        expect {
          subject.cancel!(subject.cancelation_token)
        }.to change { subject.reload.canceled_at }.from(nil).to Time.zone.now
      end
    end
  end

  describe '#canceled?' do
    it 'exists' do
      expect(subject).to respond_to(:canceled?).with(0).arguments
    end

    it 'returns true if the record is canceled' do
      subject = FactoryGirl.build :offer, :canceled
      expect(subject.canceled?).to be true
    end

    it 'returns false if the record is not canceled' do
      expect(subject.canceled?).to be false
    end
  end

  it { should respond_to :part_one_confirmation_code }
  it { should respond_to :part_two_confirmation_code }

  describe '#part_one_confirmation_code' do
    it 'returns the first half of the code' do
      subject.save!
      expected = subject.confirmation_token[0..2]
      expect(subject.part_one_confirmation_code).to eql expected
    end
  end

  describe '#part_two_confirmation_code' do
    it 'returns the second half of the code' do
      subject.save!
      expected = subject.confirmation_token[3..5]
      expect(subject.part_two_confirmation_code).to eql expected
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
end
