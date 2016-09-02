FactoryGirl.define do
  factory :region do
    name { FFaker::AddressDE.city }
    sequence(:slug) { |n| 'slug%02d'%[n] }
    country { FFaker::AddressDE.country }
    sender_email { FFaker::Internet.email }
  end

end
