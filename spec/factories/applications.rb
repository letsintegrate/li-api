FactoryGirl.define do
  factory :application, class: Doorkeeper::Application do
    sequence(:name) { |n| 'Application%02d'%[n] }
    redirect_uri 'urn:ietf:wg:oauth:2.0:oob'
  end
end
