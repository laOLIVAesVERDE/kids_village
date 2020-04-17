class Facility < ApplicationRecord
  belongs_to :user
  has_many :kids, dependent: :destroy
  has_many :posts, dependent: :destroy
  validates :name, presence: true,
                   length: { maximum: 50 }
  validates :user_id, presence: true
end
