Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'toppages#index'
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  get 'signup', to: 'users#new'
  resources :users, only: [:index, :show, :new, :create] do
   member do
     get :followings
     get :followers
     get :favoriteposts
     get :likes #お気に入りした投稿ページを表示させるアクション
   end
  end
  
  resources :microposts, only: [:create, :destroy] do
      member do
        get :favoriteusers
      end
  end
  
  #ログインユーザがユーザーをフォロー/アンフォローできるようにするルーティング
  resources :relationships, only: [:create, :destroy]
  resources :favorite_rsps, only: [:create, :destroy]
  
end
