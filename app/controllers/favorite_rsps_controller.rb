class FavoriteRspsController < ApplicationController
  before_action :require_user_logged_in

  def create
    micropost = Micropost.find(params[:favorite_id])
    current_user.favorite(micropost)
    flash[:success] = 'ツイートをお気に入り登録しました。'
    redirect_back(fallback_location: root_path)
    
  end

  def destroy
    micropost = Micropost.find(params[:favorite_id])
    current_user.unfavorite(micropost)
    flash[:success] = 'POSTをお気に入りから解除しました。'
    redirect_back(fallback_location: root_path)
    
  end
end
