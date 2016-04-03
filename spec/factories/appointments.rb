FactoryGirl.define do
  factory :appointment do
    offer_time
    offer { offer_time.offer }
    email { FFaker::Internet.email }

    trait :confirmed do
      confirmed_at { FFaker::Time.date }
    end

    trait :cancel_requested do
      after(:build) do |appointment|
        appointment.cancel
      end
    end
  end

end
