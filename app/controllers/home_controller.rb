class HomeController < ApplicationController

  def index
  end

  def profile
    # FIXME: Find current user
    @user_info = Member.find(:first)
    @notifications = Member.find(:first).notifications
    @friends = Member.find(:first).friends
    @friend_requests_sent = Member.find(:first).friend_requests
    @friend_requests_received = Member.find(:first).friend_requests#_received
    @calendars = Member.find(:first).calendars
  end

end
