class Image < ActiveRecord::Base
  # Uploader
  #
  mount_uploader :file, ImageUploader

  # Validations
  #
  validates :file, presence: true

  # Image upload
  #
  def file=(file)
    if file.kind_of?(Hash)
      file = ActionDispatch::Http::UploadedFile.new(
        filename:     file['original_filename'],
        content_type: file['content_type'],
        tempfile:     File.new(file['path'], 'r')
      )
    end
    super(file)
  end
end
