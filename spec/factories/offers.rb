FactoryGirl.define do
  factory :offer do
    email { FFaker::Internet.email }
    locations { [FactoryGirl.build(:location)] }
    offer_times { [FactoryGirl.build(:offer_time, offer: nil)] }

    trait :confirmed do
      confirmed_at { 1.minute.ago }
    end

    trait :canceled do
      canceled_at { 1.minute.ago }
    end

    trait :upcoming do
      offer_times { [FactoryGirl.build(:offer_time, :upcoming)] }
    end

    trait :expired do
      offer_times { [FactoryGirl.build(:offer_time, :expired)] }
    end

    trait :phone_required do
      locations { [FactoryGirl.build(:location, :phone_required)] }
      phone '+491771234567'
    end
  end

end
