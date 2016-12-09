FactoryGirl.define do
  factory :widget do
    container_name 'before_content'
    page
    sequence(:position) { |n| n }

    factory :content_widget, class: ContentWidget do
      content     'FooBar'
      class_names 'foo'
    end
  end

end
