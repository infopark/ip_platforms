module MembersHelper

  def member_state_select_tag(selected_state)
    options = [
      ['all member states', ''],
      ['only members who are not yet contacts of mine', 'noFriends'],
      ['only members who have not yet received an RCD from me', 'noRCD'],
    ]
    select_tag('state', options_for_select(options, selected_state))
  end

  def member_location_select_tag(selected_location)
    options = [
      ['members at all locations', ''],
    ]
    if @current_user
      unless @current_user.town.blank?
        options << ["only members in #{@current_user.town}", 'myTown']
      end
      unless @current_user.country.blank?
        options << ["only members in #{@current_user.country}", 'myCountry']
      end
      if @current_user.has_gps_data?
        [5, 10, 20, 50, 100, 200, 500, 1000, 2000, 5000].each do |distance|
          ["only members who live <#{distance}km away", distance]
        end
      end
    end
    select_tag(:location, options_for_select(options, selected_location))
  end

  def is_my_profile?
    @member == @current_user
  end

  def is_friend?(user)
    @current_user.friends.exists?(user)
  end

  def is_pending_friend?(user)
    @current_user.friend_requests_received.exists?(user) ||
    user.friend_requests_received.exists?(@current_user)
  end

  def show_details?(user=@user)
    return false if !logged_in?
    return true if user && is_my_profile?
    return true if is_admin?
    is_friend?(user)
  end

end
