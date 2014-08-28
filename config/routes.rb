Givr::Application.routes.draw do
  get "password_resets/create"
  get "password_resets/edit"
  get "password_resets/update"
  get "oauths/oauth"
  get "oauths/callback"
  root to: 'pages#index'
  resources :projects do
    resources :applications, only: [:show,:create, :edit, :update, :destroy]
  end 
  get 'projects/:id/show' => 'projects#show_html', as: 'show_html_project'
  get 'projects/:id/load_app' => 'projects#load_application', as: 'load_application'
  post 'projects/filter' => 'projects#index', as: 'filter_projects'
  put 'projects/:project_id/applications/:id/creator' => 'applications#project_creator_update', as: 'creator_update'
  put 'projects/:project_id/applications/:id/applicant' => 'applications#applicant_update', as: 'applicant_update'
  get 'projects/:project_id/applications/:id/complete' => 'applications#complete', as: 'complete_application'
  get 'projects/:project_id/applications/:id/user_edit' => 'applications#user_edit', as: 'application_user_edit'
  resources :users, only: [:show, :new, :create, :edit, :update, :destroy]
  patch 'user/upload_resume' => 'users#upload_resume'
  patch 'user/upload_logo' => 'users#upload_logo'
  get 'user/profile' => 'users#profile', as: 'user_profile'
  patch 'user/update_role' => 'users#update_role', as: 'update_role'
  get 'organization/:id' => 'users#organization_profile', as: 'organization_profile'
  patch 'applications/read_applications' => 'applications#read', as: 'read_applications'
  post 'oauth/callback' => 'oauths#callback'
  get 'oauth/callback' => 'oauths#callback'
  get 'oauths/:provider' => 'oauths#oauth', as: 'auth_at_provider'
  resources :sessions, only: [:create, :destroy]
  resources :password_resets, only: [:create, :edit, :update]
  resources :project_views, only: [:update]
  post 'subscribe/:id' => 'pages#subscribe', as: 'subscribe'
  put 'projects/:id/admin_update' => 'projects#admin_update', as: 'project_admin_update'
  resources :categories, only: [:new, :create, :edit, :update, :destroy]
  resources :causes, only: [:new, :create, :edit, :update, :destroy]
  resources :locations, only: [:new, :create, :edit, :update, :destroy]
  mount Monologue::Engine, at: '/blog' # or whatever path, be it "/blog" or "/monologue"

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
