class Widget < ActiveRecord::Base
  # Relationships
  #
  belongs_to :page

  # Translations
  #
  translates :content
  translates :data

  # Type attributes
  #
  store_accessor :global_data, :class_names
end
