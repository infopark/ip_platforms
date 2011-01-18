IpPlatforms::Application.routes.draw do

  resources :calendars
  resources :categories
  resources :conferences
  resources :members
  resources :series
  root(:to => 'home#index', :as => :home)
  match('/my_cap' => 'home#profile')

end
