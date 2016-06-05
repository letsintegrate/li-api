class User < ActiveRecord::Base
  # Secure password
  has_secure_password

  # Validations
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, password_strength: {
    use_dictionary: true,
    min_word_length: 8
  }, if: :validate_password

  attr_reader :validate_password

  def password=(value)
    @validate_password = true
    super
  end
end
