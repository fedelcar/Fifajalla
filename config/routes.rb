Rails.application.routes.draw do

  root 'welcome#index'
  get 'welcome/faqs'
  get 'welcome/history'
 
  post 'users/new', to: 'users#new'
  get 'cPanel', to: 'users#cPanel'
  get 'admin', to: 'users#admin'
  post 'admin', to: 'users#givePick'
  post 'users', to: 'users#givePick'
  patch 'users', to: 'users#update'
  get 'users/destroy', to:'users#destroy'
  resources :users

  get 'players/stats'
  post 'players', to: 'players#index'
  get 'players/search'
  get 'players/download'
  get 'players/addToTradeBlock', to: 'players#TradeBlock'
  get 'players/protectPlayer', to: 'players#protectPlayer'
  get 'players/hacerTitular', to: 'players#hacerTitular'
  get 'players/releasePlayer', to: 'players#releasePlayer'
  post 'players/movePlayer', to: 'players#movePlayer'
  resources :players

  get 'trades/addToTradeBlock'
  get 'trades/onTheBlock'
  get 'trades/new'
  get 'trades/my', to: 'trades#my'
  get 'trades/proposedTrades', to: 'trades#proposedTrades'
  get 'trades/approveTrade', to: 'trades#approveTrade'
  get 'trades/rejectTrade', to: 'trades#rejectTrade'
  get 'trades/cancelTrade', to: 'trades#cancelTrade'
  resources :trades

  get 'draft/givePicks', to: 'draft#givePicks'
  get 'draft/draftPlayer', to: 'draft#draftPlayer'
  get 'draft/wanted', to: 'draft#wanted'
  get 'draft/removeWanted', to:'draft#removeWanted'
  get 'draft/addWanted', to:'draft#addWanted'
  get 'draft/released'
  resources :draft

  post 'teams/new', to: 'teams#create'
  get 'teams/addToTradeBlock', to: 'teams#TradeBlock'
  get 'teams/destroy', to:'teams#destroy'
  resources :teams
  
  post 'matches', to: 'matches#newMatch'
  post 'matches/new', to: 'matches#newMatch'
  get 'matches/newReal', to: 'matches#newReal'
  post 'matches/newReal', to: 'matches#newRealMatch'
  get 'matches/my', to:'matches#my'
  post 'matches#editUser', to: 'matches#editUser'
  post 'matches#createEvent', to: 'matches#createEvent'
  get 'matches/schedule', to: 'matches#schedule'
  get 'matches/destroy', to:'matches#destroy'
  get 'matches/deleteEvent', to: 'matches#deleteEvent'
  resources :matches

  get 'league/new', to: 'league#new'
  post 'league/new', to: 'league#create'
  get 'league/changeFinished', to: 'league#changeFinished'
  resources :league

  get 'download', to: 'welcome#download'
  
  get 'head_to_head/index'
  get 'head_to_head/table'
  get 'head_to_head/show'
  get 'head_to_head/table'

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
