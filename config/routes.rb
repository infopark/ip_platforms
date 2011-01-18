IpPlatforms::Application.routes.draw do

  get "factorydefaults" => "seed#factorydefaults"
  get "reset" => "seed#reset"
  match('/defriend/:id' => 'members#defriend', :as => :defriend)
  match('/add_rcd/:id' => 'members#add_rcd', :as => :add_rcd)
  match('/accept_rcd/:id' => 'members#accept_rcd', :as => :accept_rcd)
  match('/decline_rcd/:id' => 'members#decline_rcd', :as => :decline_rcd)
  match('/members/:id/edit_password' => 'members#edit_password',
        :as => :edit_password)
  match('/revoke_friend_request/:id' => 'members#revoke_friend_request',
        :as => :revoke_friend_request)
  resource(:login_session, :only => [:create, :destroy, :new])
  resources(:calendars)
  resources(:categories)
  resources(:conferences) do
    get "signout", :on => :member
    get "signup", :on => :member
    get "invite", :on => :member
  end
  resources(:members)
  resources(:series)
  root(:to => 'home#index', :as => :home)

end
