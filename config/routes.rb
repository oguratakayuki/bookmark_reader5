Rails.application.routes.draw do

  require 'sidekiq/web'
  Rails.application.routes.draw do
    mount Sidekiq::Web => '/sidekiq'
  end 

  root to: 'histories#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :histories do
    resources :folders do
      get 'child_folders', on: :member
      resources :bookmarks do
        put 'sync_body', on: :member
      end
    end
  end
end
