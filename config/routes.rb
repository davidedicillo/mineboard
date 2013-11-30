Mineboard::Application.routes.draw do

  get '/servers/update_all', to: "servers#update_all"

  resources :servers

  root 'welcome#index'

  resources :stats

end
