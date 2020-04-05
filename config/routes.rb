Rails.application.routes.draw do
  devise_for :users
  
  get 'persons/profile'
  
  resources :journals do
    resources :publications do
      resources :uroles
       
      resources :articles do
        resources :materials do
          collection do 
            post 'sort'
          end
          get 'pdf'

        end  
        
        resources :paternities do
          collection do 
            post 'sort'
          end
        end  
        
        resources :comments
        resources :appointments
      end
      
      get 'pdf'

      resources :portions do
        get 'pdf'
        collection do 
          post 'sort'
        end
      end
    end
  end
  
  resources :institutions
  resources :authors do
    resources :degrees do
      collection do
        post 'sort'
      end
    end  
  end
  
  resources :conversations, only: [:index, :show, :destroy]
  resources :messages, only: [:new, :create]
  get 'help_topics/update_neighbours', as: 'update_neighbours' 
  resources :help_topics do
    get 'update_neighbours', as: 'update_neighbours'   
  end
  resources :global_params

  get 'about/index'
  get 'about/service'
  get 'about/prices'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'about#index'

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
  
  TheRoleManagementPanel::Routes.mixin(self)
end
