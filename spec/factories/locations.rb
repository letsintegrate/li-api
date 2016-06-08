FactoryGirl.define do
  factory :location do
    sequence(:name) { |n| 'Location %02d'%[n] }
    description { FFaker::Lorem.paragraph }
    images [
      'http://lorempixel.com/800/600/city/1/',
      'http://lorempixel.com/800/600/city/3/'
    ]
    sequence(:slug) { |n| 'location-%02d'%[n] }

    trait :phone_required do
      phone_required true
    end
  end

end
