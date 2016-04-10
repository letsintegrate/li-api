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
  it { should allow_value('john@example.com').for(:email) }
  it { should_not allow_value('john.example.com').for(:email) }

  # Methods
  it { should respond_to(:confirm!).with(1).argument }
  it { should respond_to(:cancel!).with(1).argument }
  it { should respond_to(:cancel).with(0).argument }

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
    subject { FactoryGirl.create :appointment, :cancel_requested }

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

  describe '#cancel' do
    it 'creates a cancelation token' do
      subject.save!
      expect {
        subject.cancel
      }.to change { subject.reload.cancelation_token }.from(nil)
    end
  end

  # Token generation
  it 'generates a confirmation token on create' do
    subject.save!
    expect(subject.confirmation_token).not_to be_nil
  end

  # Pending
  pending 'email sending'
end