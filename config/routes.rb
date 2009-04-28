ActionController::Routing::Routes.draw do |map|
  
  # See how all your routes lay out with "rake routes"

  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.register '/register', :controller => 'registrations', :action => 'new'
  
  map.resources :projects do |project|
    project.resources :project_administrators, :as => 'admin-users', :except => [:edit, :update]
    project.resources :project_members, :as => 'member-users', :except => [:edit, :update]
    project.resources :project_admin_groups, :as => 'admin-groups', :except => [:edit, :update]
    project.resources :project_member_groups, :as => 'member-groups', :except => [:edit, :update]
    project.resources :project_news_items, :as => 'news-items'
    project.resources :project_mailing_lists, :name_prefix => "", :as => 'mailing-lists'
    project.resources :project_tags, :as => 'tags', :only => [:index, :create, :destroy]
    project.resource  :issue_tracker
    project.resources :downloads
    project.resources :download_requests, :only => [:create]
    project.resources :images, :only => [:show]
  end  
  
  map.connect '/project-sites/:shortname', :controller => 'projects', :action => 'show'
  map.project_administration '/project/:id/project_administration', :controller => 'project_administration', :action => 'index'
  
  map.admin 'admin', :controller => 'admin', :action => 'index'
  map.resources :news_items, :path_prefix => "/admin", :as => 'news-items'
  map.resources :featured_projects, :path_prefix => "/admin", :as => 'featured'
  map.resources :project_categories, :path_prefix => "/admin", :as => 'categories'
  map.resources :project_maturities, :path_prefix => "/admin", :as => 'maturities'
  map.resources :project_licenses, :path_prefix => "/admin", :as => 'licenses'
  map.resources :project_statuses, :path_prefix => "/admin", :as => 'statuses'
  map.resources :unapproved_projects, :path_prefix => "/admin", :only => [:index, :show, :update, :destroy]

  
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "homepage"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
end
