FactoryGirl.define do
  factory :page do
    sequence(:id)    { |n| 'page-%02d'%[n] }
    sequence(:title) { |n| 'Page #%02d'%[n] }
    content 'text'
  end

end
