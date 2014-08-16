Rails.application.routes.draw do
 
  get 'users/cPanel'

  get 'welcome/faqs'

  patch 'users', to: 'users#update'
  
  resources :users

  get 'players/stats'

  get 'players/search'

  get 'players/download'

  get 'trades/addToTradeBlock'

  get 'trades/onTheBlock'

  get 'trades/new'

  root 'welcome#index'
  
  get 'players/addToTradeBlock', to: 'players#TradeBlock'

  get 'teams/addToTradeBlock', to: 'teams#TradeBlock'

  get 'draft/draftPlayer', to: 'draft#draftPlayer'



  post 'matches', to: 'matches#newMatch'

  post 'matches#createEvent', to: 'matches#createEvent'


  get 'trades/proposedTrades', to: 'trades#proposedTrades'

  get 'trades/approveTrade', to: 'trades#approveTrade'

  get 'trades/rejectTrade', to: 'trades#rejectTrade'

  resources :draft

  resources :trades

  resources :players

  resources :stats
  
  resources :league
  
  resources :matches
  
  resources :teams


  #Everything below is for facebook OAuth
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'

  resources :sessions, only: [:create, :destroy]
  resource :welcome, only: [:index]

  

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
