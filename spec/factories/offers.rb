FactoryGirl.define do
  factory :offer do
    email { FFaker::Internet.email }
    locations { [FactoryGirl.build(:location)] }
    offer_times { [FactoryGirl.build(:offer_time, offer: nil)] }

    trait :confirmed do
      confirmed_at { Time.zone.now }
    end

    trait :upcoming do
      offer_times { [FactoryGirl.build(:offer_time, :upcoming)] }
    end

    trait :expired do
      offer_times { [FactoryGirl.build(:offer_time, :expired)] }
    end
  end

end
