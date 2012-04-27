BrockhillForecaster::Application.routes.draw do
  root :to => 'forecast#index'
  resources :forecast, :only => [:index]
end
