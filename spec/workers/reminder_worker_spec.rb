require 'rails_helper'
RSpec.describe ReminderWorker, type: :worker do
  # Methods
  it { should respond_to :reminder_records }
  it { should respond_to :send_reminder }

  describe '#reminder_records' do
    it 'returns a relation' do
      expect(subject.reminder_records).to be_an ActiveRecord::Relation
    end

    it 'contains appointments within the next 8 and 9 hours' do
      ot = FactoryGirl.create :offer_time, :confirmed, time: (8.hours.from_now + 30.minutes)
      a  = FactoryGirl.create :appointment, :confirmed, offer: ot.offer, offer_time: ot
      expect(subject.reminder_records).to include a
    end

    it 'excludes not confirmed appointments' do
      ot = FactoryGirl.create :offer_time, :confirmed, time: (8.hours.from_now + 30.minutes)
      a  = FactoryGirl.create :appointment, offer: ot.offer, offer_time: ot
      expect(subject.reminder_records).to_not include a
    end

    it 'excludes appointments 10 hours from now' do
      ot = FactoryGirl.create :offer_time, :confirmed, time: 10.hours.from_now
      a  = FactoryGirl.create :appointment, :confirmed, offer: ot.offer, offer_time: ot
      expect(subject.reminder_records).to_not include a
    end

    it 'excludes appointments 7 hours from now' do
      ot = FactoryGirl.create :offer_time, :confirmed, time: 7.hours.from_now
      a  = FactoryGirl.create :appointment, :confirmed, offer: ot.offer, offer_time: ot
      expect(subject.reminder_records).to_not include a
    end

    it 'excludes notified appointments' do
      ot = FactoryGirl.create :offer_time, :confirmed, time: (8.hours.from_now + 30.minutes)
      a  = FactoryGirl.create :appointment, :confirmed, offer: ot.offer, offer_time: ot, reminder_sent: 1.hour.ago
      expect(subject.reminder_records).to_not include a
    end
  end
end
