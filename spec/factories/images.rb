FactoryGirl.define do
  factory :image do
    file do
      {
        'original_filename' => '',
        'content_type'      => 'image/jpeg',
        'path'              => Rails.root.join('spec', 'fixtures', 'paul.jpg').to_s
      }
    end
  end

end
