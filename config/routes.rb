IpPlatforms::Application.routes.draw do

  get "factorydefaults" => "seed#factorydefaults"
  get "reset" => "seed#reset"
  match('/accept_friend_request/:id' => 'profile#accept_friend_request',
        :as => :accept_friend_request)
  match('/decline_friend_request/:id' => 'profile#decline_friend_request',
        :as => :decline_friend_request)
  match('/members/:id/edit_password' => 'members#edit_password',
        :as => :edit_password)
  match('/profile(/:id)' => 'profile#index', :as => :profile)
  match('/revoke_friend_request/:id' => 'profile#revoke_friend_request',
        :as => :revoke_friend_request)
  resource(:login_session, :only => [:create, :destroy, :new])
  resources(:calendars)
  resources(:categories)
  resources(:conferences)
  resources(:members)
  resources(:series)
  root(:to => 'home#index', :as => :home)

end
