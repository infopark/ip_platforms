IpPlatforms::Application.routes.draw do

  get "reset" => "seed#reset"
  get "factorydefaults" => "seed#factorydefaults"
  match('/profile(/:id)' => 'profile#index', :as => :profile)
  match('/members/:id/edit_password' => 'members#edit_password',
        :as => :edit_password)
  resource(:login_session, :only => [:create, :destroy, :new])
  resources(:calendars)
  resources(:categories)
  resources(:conferences) do
    get "signup", :on => :member
  end
  resources(:members)
  resources(:series)
  root(:to => 'home#index', :as => :home)

end
