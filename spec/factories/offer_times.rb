FactoryGirl.define do
  factory :offer_time do
    offer
    time { FFaker::Time.date }

    trait :confirmed do
      offer { FactoryGirl.build :offer, :confirmed }
    end
  end

end
