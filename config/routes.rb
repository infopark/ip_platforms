IpPlatforms::Application.routes.draw do

  match('/defriend/:id' => 'members#defriend', :as => :defriend)
  match('/add_rcd/:id' => 'members#add_rcd', :as => :add_rcd)
  match('/accept_rcd/:id' => 'members#accept_rcd', :as => :accept_rcd)
  match('/decline_rcd/:id' => 'members#decline_rcd', :as => :decline_rcd)
  match('/revoke_rcd/:id' => 'members#revoke_rcd', :as => :revoke_rcd)
  match('/toggle_admin/:id' => 'members#toggle_admin', :as => :toggle_admin)
  match('/members/:id/edit_password' => 'members#edit_password',
        :as => :edit_password)
  resource(:login_session, :only => [:create, :destroy, :new])
  resources(:calendars)
  resources(:categories, :except => :show)
  resources(:conferences) do
    member do
      get :signout
      get :signup
      get :invite
      get :add_to_calendar
    end
  end
  resources(:members)
  resources(:series, :except => :show)
  resource(:ws, :only => []) do
    collection do
      get :factorydefaults
      get :reset
    end
  end

  root(:to => 'home#index', :as => :home)

end
