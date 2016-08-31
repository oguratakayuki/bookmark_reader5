Rails.application.routes.draw do
  root to: 'histories#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :histories do
    resources :folders do
      get 'child_folders', on: :member
      resources :bookmarks
    end
  end
end
