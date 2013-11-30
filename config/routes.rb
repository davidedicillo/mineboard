Mineboard::Application.routes.draw do

  get '/servers/update_all', to: "servers#update_all"

  resources :servers

  root 'stats#index'

  resources :stats

end
