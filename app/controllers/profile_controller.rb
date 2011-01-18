class ProfileController < ApplicationController

  append_before_filter :require_current_user

  def index
    if params[:id]
      @user = Member.find(params[:id])
    else
      @user = @current_user
      @notifications = @user.notifications
      @friends = @user.friends
      @friend_requests_sent = @user.friend_requests_sent
      @friend_requests_received = @user.friend_requests_received
      @calendars = @user.calendars
    end
  end

  def accept_friend_request
    begin
      @current_user.accept_friend_request(params[:id])
      flash[:notice] = 'Friend request accepted'
    rescue => e
      flash[:error] = "Could not accept friend request (#{e})"
    end
    redirect_to(profile_path)
  end

  def decline_friend_request
    begin
      @current_user.decline_friend_request(params[:id])
      flash[:notice] = 'Friend request declined'
    rescue => e
      flash[:error] = "Could not decline friend request (#{e})"
    end
    redirect_to(profile_path)
  end

  def revoke_friend_request
    begin
      @current_user.revoke_friend_request(params[:id])
      flash[:notice] = 'My friend request has been revoked'
    rescue => e
      flash[:error] = "Could not revoke friend my request (#{e})"
    end
    redirect_to(profile_path)
  end

end
