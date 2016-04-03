FactoryGirl.define do
  factory :offer_time do
    offer
    time { FFaker::Time.date }
  end

end
