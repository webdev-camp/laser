Rails.application.routes.draw do
  resources :laser_gems
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "main#home"
end
