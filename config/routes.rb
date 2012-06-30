Epdp::Application.routes.draw do

  get "comments/index"
  get "comments/edit"
  resources "reflection"
  resources "scorecard"
  resources "scoreentry"
  resources "progress"
  resources "help"

  get "progressreport/index"
  get "progressreport/admin"
  resources :goals do
      resources :tasks
  end
    
  # get "users/show"

  root :to => "home#index"
  devise_for :users
  resources :users, :only => :show
    
    devise_for :users, :controllers => {:sessions => 'home'}, :skip => [:sessions] do
        post '' => 'home#index', :as => :user_session, 'f' => '1'
        get '' => 'home#index', :as => :new_user_session
        post 'reg' => 'users/registrations#create', :as => :user_registration
        delete 'reg' => 'users/registrations#destroy', :as => :destroy_user_registration
        get 'reg' => 'home#index'
        put 'reg' => 'users/registrations#update', :as => :update_user_registration
    end
	
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
   root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
