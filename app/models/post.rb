class Post < ApplicationRecord
  belongs_to :facility
  default_scope -> { order(created_at: :desc) }
  validates :title, presence: true, length: {maximum: 50}
  validates :content, presence: true,
                      length: {maximum: 400, minimum: 10}
  validates :facility_id, presence: true
end
