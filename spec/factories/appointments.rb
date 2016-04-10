FactoryGirl.define do
  factory :appointment do
    offer_time { offer.offer_times.first }
    offer
    location { offer.locations.first }
    email { FFaker::Internet.email }

    trait :confirmed do
      confirmed_at { FFaker::Time.date }
    end
  end

end
