class Location < ActiveRecord::Base
  # Translations
  #
  translates :description

  # Relationships
  #
  belongs_to :region, required: true
  has_many :offer_locations
  has_many :offers, through: :offer_locations

  # Images
  #
  mount_uploaders :images, LocationImageUploader

  # Validations
  #
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :slug, presence: true, uniqueness: { case_sensitive: false }

  # Scopes
  #
  scope :active, -> { where(active: true) }
  scope :regular, -> { where(special: false) }
  scope :sp, -> { where(special: true) }

  def self.r(region)
    if UUID.validate(region)
      where(region_id: region)
    else
      joins(:region).where(regions: { slug: region })
    end
  end

  # Ransack
  #
  def self.ransackable_scopes(_auth_object = nil)
    %i(r regular sp)
  end

  # Image upload
  #
  def new_images=(images)
    self.images += images.map do |image|
      ActionDispatch::Http::UploadedFile.new(
        filename:     image['original_filename'],
        content_type: image['content_type'],
        tempfile:     File.new(image['path'], 'r')
      )
    end
  end

  def new_images
    []
  end
end
