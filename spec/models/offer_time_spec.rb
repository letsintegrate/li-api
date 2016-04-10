require 'rails_helper'

RSpec.describe OfferTime, type: :model do
  subject { FactoryGirl.build :offer_time }

  let(:offer_time) { FactoryGirl.create :offer_time, :confirmed }
  let(:location) { offer_time.offer.locations.first }

  # Attributes
  it { should have_db_column(:id).of_type :uuid }
  it { should have_db_column(:offer_id).of_type :uuid }
  it { should have_db_column(:time).of_type :datetime }

  # Relationships
  it { should belong_to :offer }

  # Validations
  it { should validate_presence_of  :offer }
  it { should validate_presence_of  :time }

  # Scopes
  describe '#confirmed' do
    it 'contains confirmed records' do
      FactoryGirl.create_list :offer, 3, :confirmed
      expect(OfferTime.confirmed.count).to eql(3)
    end

    it 'does not contains unconfirmed records' do
      FactoryGirl.create_list :offer, 3
      expect(OfferTime.confirmed.count).to eql(0)
    end
  end

  describe '#not_taken' do
    it 'contains offers which are not taken' do
      offer = FactoryGirl.create :offer, :confirmed
      offer_time = offer.offer_times.first
      expect(OfferTime.not_taken).to include offer_time
    end

    it 'does not contain offers that have shortly be taken but not confirmed' do
      offer = FactoryGirl.create :offer, :confirmed
      offer_time = offer.offer_times.first
      appointment = FactoryGirl.create :appointment,
                                       location: offer.locations.first,
                                       offer_time: offer.offer_times.first,
                                       offer: offer
      expect(OfferTime.not_taken).to_not include offer_time
    end

    it 'contains offers that where taken over 2 hours ago but not confirmed' do
      offer = FactoryGirl.create :offer, :confirmed
      offer_time = offer.offer_times.first
      appointment = FactoryGirl.create :appointment,
                                       location: offer.locations.first,
                                       offer_time: offer.offer_times.first,
                                       offer: offer,
                                       created_at: 3.hours.ago
      expect(OfferTime.not_taken).to include offer_time
    end

    it 'dose not contain offers have been taken 2 hours ago and have been confirmed' do
      offer = FactoryGirl.create :offer, :confirmed
      offer_time = offer.offer_times.first
      appointment = FactoryGirl.create :appointment, :confirmed,
                                       location: offer.locations.first,
                                       offer_time: offer.offer_times.first,
                                       offer: offer,
                                       created_at: 3.hours.ago
      expect(OfferTime.not_taken).to_not include offer_time
    end
  end

  describe '#location' do
    subject { OfferTime.location(location.id) }
    let(:offer_time_two) { FactoryGirl.create :offer_time }

    before(:each) { offer_time; offer_time_two }

    it 'contains offer times within the given location' do
      expect(subject).to include offer_time
    end

    it 'excludes other locations' do
      expect(subject).to_not include offer_time_two
    end
  end

  describe '#upcoming' do
    it 'includes upcomming offer times' do
      offer_time = FactoryGirl.create :offer_time, :confirmed, :upcoming
      expect(OfferTime.upcoming).to include offer_time
    end

    it 'excludes expired offer times' do
      offer_time = FactoryGirl.create :offer_time, :confirmed, :expired
      expect(OfferTime.upcoming).to_not include offer_time
    end
  end

  describe '#not_canceled' do
    it 'includes not canceled offer times' do
      offer_time = FactoryGirl.create :offer_time, :confirmed, :upcoming
      expect(OfferTime.not_canceled).to include offer_time
    end

    it 'excludes canceled offer times' do
      offer_time = FactoryGirl.create :offer_time, :canceled, :upcoming
      expect(OfferTime.not_canceled).to_not include offer_time
    end
  end
end
