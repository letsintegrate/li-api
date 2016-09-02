class Region < ActiveRecord::Base
  # Relationships
  #
  has_many :locations

  # Validations
  #
  validates :country, presence: true
  validates :name, presence: true
  validates :sender_email, presence: true
  validates :slug, presence: true, uniqueness: { case_sensitive: false }

  # Scopes
  #
  scope :active, -> { where(active: true) }
end
