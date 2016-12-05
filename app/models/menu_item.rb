class MenuItem < ActiveRecord::Base
  # Relationships
  #
  belongs_to :page, required: true

  # Validations
  #
  validates :name, presence: true
end
