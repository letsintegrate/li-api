class OfferTime < ActiveRecord::Base
  # Relationships
  belongs_to :offer, required: true

  # Validations
  validates :time, presence: true
end
