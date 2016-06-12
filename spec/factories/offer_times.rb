FactoryGirl.define do
  factory :offer_time do
    offer
    time { FFaker::Time.date }

    trait :confirmed do
      offer { FactoryGirl.build :offer, :confirmed }
    end

    trait :canceled do
      offer { FactoryGirl.build :offer, :confirmed, :canceled }
    end

    trait :upcoming do
      sequence(:time) { |n| 30.hours.from_now }
    end

    trait :expired do
      sequence(:time) { |n| 30.minutes.from_now }
    end
  end

end
