Rails.application.routes.draw do
  resources :laser_gems
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "main#home"
    get '/about', to: 'main#about', as: 'about'
    get '/faq', to: 'main#faq', as: 'faq'
    get '/ruby_for_newbies', to: 'main#ruby_for_newbies', as: 'ruby_for_newbies'

end
