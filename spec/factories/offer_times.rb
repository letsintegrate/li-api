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
      sequence(:time) { |n| Time.now + n.hours }
    end

    trait :expired do
      sequence(:time) { |n| Time.now - n.hours }
    end
  end

end
