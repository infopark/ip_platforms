IpPlatforms::Application.routes.draw do

  get "reset" => "seed#reset"
  get "factorydefaults" => "seed#factorydefaults"
  match('/profile' => 'profile#index', :as => :profile)
  resource(:login_session, :only => [:create, :destroy, :new])
  resources(:calendars)
  resources(:categories)
  resources(:conferences)
  resources(:members)
  resources(:series)
  root(:to => 'home#index', :as => :home)

end
