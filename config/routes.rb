Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :apis do
    namespace :v1 do
      resources :buildings, only: [:index, :create, :update]
    end
  end

end
