Rails.application.routes.draw do

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

namespace :api do
  namespace :v1 do
    post 'users/sign_in', to: 'users#sign_in', as: :sign_in
    post 'users/sign_up', to: 'users#sign_up', as: :sign_up
    get 'profile', to: 'users#show', as: :profile
    resources :groups, :only =>[:index, :show]
    
    resources :items, :only => [:show]

    resources :orders do
      collection do
        get 'active'
        post ':id/add_items/', to: 'orders#add_items', as: :add_items
        post ':id/delete_items/', to: 'orders#delete_items', as: :delete_items
        post ':id/complete/', to: 'orders#complete', as: :complete
        post ':id/select_order/', to: 'orders#select_order', as: :select_order
      end
    end
    get 'search', to: 'searches#index'
  end


  namespace :admin do
    resources :orders
    resources :users, only: [:index, :show] do
      collection do
        post ':id/update', to: 'users#update', as: :update
        post ':id/update_role', to: 'users#update_role', as: :update_role
      end
    end
    resources :activities
  end

end

  get '1c_import/:exchange_type' => "imports#index"
  post '1c_import/:exchange_type' => "imports#index" 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
