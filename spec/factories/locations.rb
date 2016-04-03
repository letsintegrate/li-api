FactoryGirl.define do
  factory :location do
    name { FFaker::AddressDE.neighborhood }
    description { FFaker::Lorem.paragraph }
    images [
      'http://lorempixel.com/800/600/city/1/',
      'http://lorempixel.com/800/600/city/3/'
    ]
    slug { FFaker::Internet.slug }
  end

end
