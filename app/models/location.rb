class Location < ActiveRecord::Base
  # Relationships
  has_many :offer_locations
  has_many :offers, through: :offer_locations

  # Validations
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :slug, presence: true, uniqueness: { case_sensitive: false }

  # Scopes
  scope :active, -> { where(active: true) }
end
