class User < ApplicationRecord
  before_save { self.email = email.downcase }
  mount_uploader :image, ImageUploader
  has_many :facilities, dependent: :destroy

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true,
                   length: {maximum: 50}
  validates :email, presence: true,
                    length: {maximum: 255},
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: {case_sensitive: false}

  has_secure_password
  validates :password, presence: true, length: {minimum: 6}
  validate :image_size

  private
    def image_size
      if image.size > 5.megabytes
        error.add(:image, 'サイズは5MB以下となります')
      end
    end

end
