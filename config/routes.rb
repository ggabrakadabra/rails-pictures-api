# frozen_string_literal: true
Rails.application.routes.draw do
  resources :comments, except: [:new, :edit]
  resources :favorites, except: [:new, :edit]
  resources :pictures, except: [:new, :edit]
  resources :search, except: [:new, :edit]
  post '/sign-up' => 'users#signup'
  post '/sign-in' => 'users#signin'
  delete '/sign-out/:id' => 'users#signout'
  patch '/change-password/:id' => 'users#changepw'
  resources :users, only: [:index, :show]

  post '/search/sounds' => 'searches#sounds_search'
  post '/search/patents' => 'searches#patents_search'
  post '/search/mars' => 'searches#mars_search'
end
