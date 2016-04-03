FactoryGirl.define do
  factory :offer do
    email { FFaker::Internet.email }
    locations { [FactoryGirl.build(:location)] }

    trait :confirmed do
      confirmed_at { Time.zone.now }
    end
  end

end
