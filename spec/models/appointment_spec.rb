require 'rails_helper'

RSpec.describe Appointment, type: :model do
  subject { FactoryGirl.build :appointment }

  # Attributes
  it { should have_db_column(:id).of_type :uuid }
  it { should have_db_column(:offer_time_id).of_type :uuid }
  it { should have_db_column(:offer_id).of_type :uuid }
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

  describe '#canceled_at' do
    subject { FactoryGirl.build(:appointment).canceled_at }

    it { should be_nil }
  end

  # Relationships
  it { should belong_to :location }
  it { should belong_to :offer }
  it { should belong_to :offer_time }

  # Validations
  it { should validate_presence_of :location }
  it { should validate_presence_of :offer }
  it { should validate_presence_of :offer_time }
  it { should validate_presence_of :email }
  it { should allow_value('john@gmail.com').for(:email) }
  it { should_not allow_value('john.gmail.com').for(:email) }

  describe 'validation' do
    it 'fails if offer has a confirmed appointment' do
      subject = FactoryGirl.create(:appointment, :confirmed)
      appointment = FactoryGirl.build(:appointment, offer: subject.offer)
      expect(appointment).to_not be_valid
    end

    it 'fails if offer has an unconfirmed valid appointment' do
      subject = FactoryGirl.create(:appointment)
      appointment = FactoryGirl.build(:appointment, offer: subject.offer)
      expect(appointment).to_not be_valid
    end

    it 'succeeds if offer has no appointment' do
      offer = FactoryGirl.create(:offer, :confirmed, :upcoming)
      appointment = FactoryGirl.build(:appointment, offer: offer)
      expect(appointment).to be_valid
    end

    it 'succeeds if offer has an outdated appointment' do
      subject     = FactoryGirl.create(:appointment, created_at: 3.hours.ago)
      appointment = FactoryGirl.build(:appointment, offer: subject.offer)
      expect(appointment).to be_valid
    end

    it 'fails with same email address within a week' do
      subject     = FactoryGirl.create(:appointment, created_at: 1.hour.from_now)
      Timecop.freeze(5.days.from_now) do
        appointment = FactoryGirl.build(:appointment, email: subject.email)
        expect(appointment).to_not be_valid
      end
    end

    it 'succeeds with same email address but more than a week later' do
      subject     = FactoryGirl.create(:appointment, created_at: 1.hour.from_now)
      Timecop.freeze(8.days.from_now) do
        appointment = FactoryGirl.build(:appointment, email: subject.email)
        expect(appointment).to be_valid
      end
    end
  end

  # Methods
  it { should respond_to(:confirm!).with(1).argument }
  it { should respond_to(:cancel!).with(1).argument }

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

  describe '#cancel!' do
    subject { FactoryGirl.create :appointment }

    it 'fails with wrong token' do
      expect {
        subject.cancel!('foo')
      }.to raise_error(TokenMissmatch)
    end

    it 'updates cancelation time with matching token' do
      Timecop.freeze(Time.local(2008, 9, 1, 12, 0, 0)) do
        expect {
          subject.cancel!(subject.cancelation_token)
        }.to change { subject.reload.canceled_at }.from(nil).to Time.zone.now
      end
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
