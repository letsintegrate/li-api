class Page < ActiveRecord::Base
  # Translations
  #
  translates :title
  translates :content

  # Validations
  #
  validates :slug, presence: true, uniqueness: { case_sensitive: false }
end
