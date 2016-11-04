Rails.application.routes.draw do

  require 'sidekiq/web'
  Rails.application.routes.draw do
    mount Sidekiq::Web => '/sidekiq'
  end 

  resources :bookmarks, only: [] do
    get 'import', on: :collection
    post 'bulk_insert', on: :collection
  end

  root to: 'folders#root'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :folders do
    get 'childs', on: :member
    resources :bookmarks do
      put 'sync_body', on: :member
    end
  end
end
