class OfferTime < ActiveRecord::Base
  # Relationships
  belongs_to :offer, required: true, inverse_of: :offer_times

  # Validations
  validates :time, presence: true
end
