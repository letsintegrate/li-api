FactoryGirl.define do
  factory :offer do
    email { FFaker::Internet.email }
    locations { [FactoryGirl.build(:location)] }
    # offer_times { [FactoryGirl.build(:offer_time, offer: self)] }

    trait :confirmed do
      confirmed_at { Time.zone.now }
    end

    after(:build) do |offer|
      if offer.offer_times.empty?
        offer_time = FactoryGirl.build :offer_time, offer: offer
        offer.offer_times = [offer_time]
      end
    end
  end

end
