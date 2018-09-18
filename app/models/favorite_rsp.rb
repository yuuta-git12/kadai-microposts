class FavoriteRsp < ApplicationRecord
  belongs_to :user
  belongs_to :favorite, class_name: 'Micropost' #class Micropostを参照するようにしている
  
  validates :user_id, presence: true
  validates :favorite_id, presence: true

end


