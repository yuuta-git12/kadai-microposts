class User < ApplicationRecord
    before_save { self.email.downcase! }
    validates :name, presence: true, length: { maximum: 50 }
    validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
    has_secure_password
    
    has_many :microposts
    has_many :relationships
    has_many :followings, through: :relationships, source: :follow 
    has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
    has_many :followers, through: :reverses_of_relationship, source: :user
    
    has_many :favorite_rsps #自分がお気に入りしているツイートへの参照
    #usersテーブルは中間テーブルfavorite_rspsを挟んで多対多の関係にある
    #中間テーブルfavorite_rspsのfavorite_idを参照しfavoritepostsを探す
    has_many :favoriteposts, through: :favorite_rsps, source: :favorite 
    
    def follow(other_user)
        #unlessは式が成り立たない場合、それ以降の処理を実行する
        #ここでは、selfの中身がother_userでない場合、それ以降の処理を実行する
        unless self == other_user
            self.relationships.find_or_create_by(follow_id: other_user.id)
        end
    end

    def unfollow(other_user)
        relationship = self.relationships.find_by(follow_id: other_user.id)
        relationship.destroy if relationship
    end

    def following?(other_user)
        self.followings.include?(other_user)
    end
    
    def favorite(post)
      self.favorite_rsps.find_or_create_by(favorite_id: post.id)
    end
    
    def unfavorite(post)
          favorite_rsp = self.favorite_rsps.find_by(favorite_id: post)
          favorite_rsp.destroy if favorite_rsp
    end
    
    def favoritepost?(post)
          self.favoriteposts.include?(post)
    end
    
    
    def feed_microposts
        #Micropost.where(user_id: フォローユーザ + 自分自身)
        Micropost.where(user_id: self.following_ids + [self.id])
    end
    
    
end
