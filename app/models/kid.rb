class Kid < ApplicationRecord
  before_save { self.email = email.downcase }
  belongs_to :facility
  default_scope -> {order(created_at: :desc)}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true,
                   length: { maximum: 50 }
  validates :school, presence: true
  validates :email, presence: true,
                    length: {maximum: 255},
                    format: { with: VALID_EMAIL_REGEX }
  validates :facility_id, presence: true

end
