Givr::Application.routes.draw do

  get "password_resets/create"
  get "password_resets/edit"
  get "password_resets/update"
  get "oauths/oauth"
  get "oauths/callback"
  root to: 'pages#index'
  resources :projects do
    resources :applications, only: [:create, :update, :destroy]
  end 
  post 'projects/filter' => 'projects#index', as: 'filter_projects'
  put 'projects/:project_id/applications/:id/creator' => 'applications#project_creator_update', as: 'creator_update'
  put 'projects/:project_id/applications/:id/applicant' => 'applications#applicant_update', as: 'applicant_update'
  resources :users, only: [:show, :new, :create, :update]
  patch 'user/upload_resume' => 'users#upload_resume'
  get 'user/profile' => 'users#profile', as: 'user_profile'
  patch 'user/update_role' => 'users#update_role', as: 'update_role'
  post 'oauth/callback' => 'oauths#callback'
  get 'oauth/callback' => 'oauths#callback'
  get 'oauths/:provider' => 'oauths#oauth', as: 'auth_at_provider'
  resources :sessions, only: [:create, :destroy]
  resources :password_resets, only: [:create, :edit, :update]


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
