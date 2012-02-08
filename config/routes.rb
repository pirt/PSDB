PSDB::Application.routes.draw do

  match 'login' => 'user_sessions#new'
  match 'logout' => 'user_sessions#destroy'

  resources :user_sessions, :only=> [:new, :create, :destroy]

  get "dynamic_images/showImage"
  get "dynamic_images/showPlot"
  get "dynamic_images/showMultiPlot"
  get "dynamic_images/showSeriesPlot"

  resources :experiments do
    resources :attachments, :only => [:show, :new, :create, :edit, :update, :destroy]
  end

  match 'shots/report/:id' => 'shots#report'
 
  resources :shots, :only => [:show, :edit, :update, :index] do
    resources :attachments, :only => [:show, :new, :create, :edit, :update, :destroy]
  end

  resources :instances, :only => [:show, :index]
  resources :instancevaluesets, :only => [:show, :index]
  resources :users

  get "instancevalues/exportImage"
  get "instancevalues/exportPlot"

  get "statistics/overview"
  get "statistics/calendar"

  get "pages/start"
  get "pages/about"
  get "pages/changelog"

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route with options:
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

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  root :to => 'user_sessions#new' #"pages#start"
  # See how all your routes lay out with "rake routes"
end
