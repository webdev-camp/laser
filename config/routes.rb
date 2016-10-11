Rails.application.routes.draw do
  match "laser_gems"        , to: "laser_gems#index" , via: [:get, :post]
  get   "laser_gem/:name"  , to: "laser_gems#show" , as: :show_laser_gem

  root to: "main#home"
    get '/about', to: 'main#about', as: 'about'
    get '/faq', to: 'main#faq', as: 'faq'
    get '/ruby_for_newbies', to: 'main#ruby_for_newbies', as: 'ruby_for_newbies'

end
