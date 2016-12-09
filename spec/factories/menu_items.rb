FactoryGirl.define do
  factory :menu_item do
    name 'nav-primary'
    page
    sequence(:position) { |n| n }
  end

end
