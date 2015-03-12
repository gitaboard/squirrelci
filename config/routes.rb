Rails.application.routes.draw do
  #resources :repositories

  get 'repositories' => 'repositories#index'
  get 'repositories/:name/search' => 'repositories#index'
  post 'repositories' => 'repositories#create'
  get 'repositories/:id' => 'repositories#index'
  post 'builds' => 'builds#create'
  get 'builds' => 'builds#index'

  get 'setup' => 'setup#index'
  post 'setup/save' => 'setup#save'

  devise_for :users, :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks' }

  devise_scope :user do
    get 'sign_in', :to => 'devise/sessions#new', :as => :new_user_session
    get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  files = Dir.glob("#{Rails.root}/app/controllers/hooks/*_controller.rb")
  puts files.inspect
  files.each do |file|
    file_header = File.open(file, &:readline)
    name = file_header.match('Hooks::(.*?)Controller').captures.join.downcase
    puts name
    controller = "hooks/#{name}#execute"
    # puts controller
    post "hooks/#{name}" => "#{controller}"
  end
  #get 'hooks/:name' => 'hooks/%{name}#execute'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'builds#index'

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
