class Micropost < ApplicationRecord
  belongs_to :user
  
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 255 }
  
  has_many :reverses_of_favorite_rsps, class_name: 'FavoriteRsp', foreign_key: 'favorite_id'
  has_many :favoriteusers, through: :reverses_of_favorite_rsps, source: :user
  
  
end
