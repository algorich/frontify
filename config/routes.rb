Frontify::Engine.routes.draw do
  resources :samples, only: [:index, :show]
end
