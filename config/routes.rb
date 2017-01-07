require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  resources :tags
  resources :categories
  devise_for :users, :controllers => {:confirmations => 'confirmations'}
  resources :announcements, except: :destroy
  match "gems", to: "laser_gems#index" , via: [:get, :post] , as: :laser_gems
  post 'gem/:name/add_tag', to: 'laser_gems#add_tag', as: :add_tag
  post 'gem/:name/add_comment', to: 'laser_gems#add_comment', as: :add_comment
  get   "gem/:name"  , to: "laser_gems#show" , as: :laser_gem
  get 'owners/index', to: 'owners#index', as: :owners_index

  root to: "main#home"
  get '/logo', to: 'main#logo', as: 'logo'
  get '/about', to: 'main#about', as: 'about'
  get '/faq', to: 'main#faq', as: 'faq'
  get '/contribute', to: 'main#contribute', as: 'contribute'
  get '/updates/show', to: 'updates#show', as:'updates_show'
  get '/updates/bounce/:gem_name', to: 'updates#bounce', as:'updates_bounce'
  post '/updates/update', to: 'updates#update', as: 'updates'

  #legacy
  get '/laser_gems',to: redirect("/gems")
  get '/laser_gem/:id',   to: redirect { |params, req| "/gem/#{params[:id]}" }

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/karate'
  end
end
