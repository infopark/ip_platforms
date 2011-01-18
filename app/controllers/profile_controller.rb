class ProfileController < ApplicationController

  def index
    require_current_user or return false
    @notifications = @current_user.notifications
    @friends = @current_user.friends
    @friend_requests_sent = @current_user.friend_requests
    @friend_requests_received = @current_user.friend_requests#_received
    @calendars = @current_user.calendars
  end

end
