Rails.application.routes.draw do
  resources :announcements
  match "laser_gems"        , to: "laser_gems#index" , via: [:get, :post]
  post 'laser_gem/:name/add_tag', to: 'laser_gems#add_tag', as: :add_tag
  get   "laser_gem/:name"  , to: "laser_gems#show" , as: :laser_gem
  get 'tags/:tag', to: 'laser_gems#index', as: :tag


  root to: "main#home"
    get '/about', to: 'main#about', as: 'about'
    get '/faq', to: 'main#faq', as: 'faq'
    get '/ruby_for_newbies', to: 'main#ruby_for_newbies', as: 'ruby_for_newbies'

end
