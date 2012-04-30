BrockhillForecaster::Application.routes.draw do
  root :to => 'home#show'

  resource :home, controller: 'home', only: [:show]
  resources :projects, only: [:index, :show] do
    resources :forecast, only: [:index]
  end
end
