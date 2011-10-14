PSDB::Application.routes.draw do
  get "dynamic_images/showImage"

  get "dynamic_images/showPlot"

  resources :experiments do
    resources :attachments
  end
  resources :shots do
    resources :attachments
  end

  resources :instances
  resources :instancevaluesets

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

  root :to => "pages#start"

  # See how all your routes lay out with "rake routes"
end
