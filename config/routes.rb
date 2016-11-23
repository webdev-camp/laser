Rails.application.routes.draw do
  devise_for :users, :controllers => {:confirmations => 'confirmations'}
  resources :announcements, except: :destroy
  match "gems", to: "laser_gems#index" , via: [:get, :post] , as: :laser_gems
  post 'gem/:name/add_tag', to: 'laser_gems#add_tag', as: :add_tag
  post 'gem/:name/add_comment', to: 'laser_gems#add_comment', as: :add_comment
  get   "gem/:name"  , to: "laser_gems#show" , as: :laser_gem
  get 'tags/:tag', to: 'laser_gems#index', as: :tag
  get 'owners/index', to: 'owners#index', as: :owners_index

  root to: "main#home"
  get '/logo', to: 'main#logo', as: 'logo'
  get '/about', to: 'main#about', as: 'about'
  get '/faq', to: 'main#faq', as: 'faq'
  get '/ruby_for_newbies', to: 'main#ruby_for_newbies', as: 'ruby_for_newbies'
  get '/updates/show', to: 'updates#show', as:'updates_show'
  post '/updates/update', to: 'updates#update', as: 'updates'

  #legacy
  get '/laser_gems',to: redirect("/gems")
  get '/laser_gem/:id',   to: redirect { |params, req| "/gem/#{params[:id]}" }

end
