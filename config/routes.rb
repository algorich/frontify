Frontify::Engine.routes.draw do
  resources :components, only: [:index, :show] do
    resources :samples, only: [:show], module: 'components'
  end
end
