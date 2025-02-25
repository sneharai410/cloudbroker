Rails.application.routes.draw do
  get 'instance_types/index'
  get 'instance_types/show'
  get 'instance_types/new'
  get 'instance_types/edit'

  root "cloudlets#home"

  # get "/home", to: "cloudlet#home" 
  get "/download_algo" , to: "simulation_results#download_algo", as: "download_algo"
 
  resources :simulation_results do 
  end
 
   resources :cloudlets do
   end 
   resources :datacenters 
   resources :instance_types
  # resources :datacenters do 
  #   resources :instance_types , shallow: true 
  # end 

  # root "simulation_results#index"

  # shallow do 
  #   resources :datacenters do 
  #     resources :instance_types
  #   end 
  # end 

  # resource :cloudlets
  # resources :datacenters do 
  #   resources :instance_types , shallow: true 
  # end 

  # generate same routes as above , 
  # shallow means that the routes will be 
  # divided into collection routes and member routes ,
  # member routes will not be nested where as 
  # the collection routes will be nest with the associated class id .
   
  # collection routes are index , new , create 
  # member routes are edit, update , destroy , show  


  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
