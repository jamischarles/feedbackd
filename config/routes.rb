Fb::Application.routes.draw do
  	# auth routes
	devise_for :users

	#routes for listings
	get "listings/detail" #simple get. Very basic output of the view...
	match "/:id" => "listings#index" #doesn't do anything currently, besides allow a param on the homepage...
	match "/listings/detail/:id" => "listings#detail"
	# match "/listings/:id" => "listings#detail"
	match "/listings/new/" => "listings#new"
	match "/listings/create/" => "listings#create" 
	
	#trying this for the post delete...
	resources :listings
	
	#ajax request for new message
	match "/listings/update_listing/" => "listings#update_listing"
	#match "/listings/:id" => "listings#update_listing"
	
	
	
	#json request for all zone data
	match "/posts/get_zones/:id" => "posts#get_zones"
	#ajax request for new zone
	match "/posts/new_zone/" => "posts#new_zone"
	

  	get "home/index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end
	
	
	
	
	#image upload. FIXME: Clean these up a little?
	resources :images #try this instead so the image upload form will output properly...
	match "upload" => "images#upload"
	match "accept" => "images#accept"
	match "reject" => "images#reject" 
	match "images/new/:id" => "images#create"
	match "images/new" => "images#create"
	match "images/delete/:id" => "images#delete"
	
	

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

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"
  root :to => "listings#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
