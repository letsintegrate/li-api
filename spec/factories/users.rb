FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| 'user%02d@letsintegrate.de'%[n] }
    password 'my secret password'
  end
end
