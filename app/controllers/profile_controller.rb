class ProfileController < ApplicationController

  append_before_filter :require_current_user

  def index
    if params[:id]
      @user = Member.find(params[:id])
    else
      @user = @current_user
    end
    @notifications = @user.notifications
    @friends = @user.friends
    @friend_requests_sent = @user.friend_requests
    @friend_requests_received = @user.friend_requests#_received
    @calendars = @user.calendars
  end

end
