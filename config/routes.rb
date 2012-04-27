BrockhillForecaster::Application.routes.draw do
  resources :forecast, :only => [:index]
end
