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
  resources(:categories, :except => :show) do
    get :create_calendar, :on => :member
  end
  resources(:conferences) do
    member do
      get :signout
      get :signup
      get :invite
      get :add_to_calendar
      get :remove_from_calendar
      get :ical
    end
  end
  resources(:members) do
    member do
      get :series
      get :add_serie
      get :remove_serie
    end
  end
  resources(:series)
  resource(:ws, :only => []) do
    collection do
      get :factorydefaults
      get :reset
    end
    resources(:conferences,
        :only => [:create, :show, :update],
        :controller => :ws_conferences) do
      resources(:attendees,
          :only => [:create, :destroy, :index],
          :controller => :ws_conference_attendees)
    end
    resources(:members,
        :only => [:create, :show, :update],
        :controller => :ws_members) do
      resources(:contacts,
          :only => [:create, :index],
          :controller => :ws_member_contacts)
    end
    resources(:categories,
        :only => [:create, :index, :show],
        :controller => :ws_categories)
    resources(:series,
        :only => [:create, :index, :show, :update],
        :controller => :ws_series)
    resources(:conferencesbycategory,
        :only => [:show],
        :controller => :ws_conferences_by_category)
    resources(:search,
        :only => [:show],
        :controller => :ws_search)
  end
  root(:to => 'home#index', :as => :home)

end
