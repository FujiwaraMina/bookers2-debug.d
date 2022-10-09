Rails.application.routes.draw do
  get "search" => "searches#search"
  get "search_tsg" => "books#search_tag"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end
  root :to =>"homes#top"
  get "home/about"=>"homes#about"

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resources :book_comments,only:[:create,:destroy]
    resource :favorites,only:[:create,:destroy]
  end
  resources :users, only: [:index,:show,:edit,:update] do
    resource :relationships,only: [:create,:destroy]
    get 'follows' => 'relationships#followings'
    get 'followers' => 'relationships#followers'

  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end