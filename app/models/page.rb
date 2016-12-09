class Page < ActiveRecord::Base
  # Relationships
  #
  has_many :menu_items
  has_many :widgets

  # Translations
  #
  translates :title
  translates :content

  # Validations
  #
  validates :id, presence: true, uniqueness: { case_sensitive: false }
end
