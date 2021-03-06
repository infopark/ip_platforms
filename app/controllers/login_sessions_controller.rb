class LoginSessionsController < ApplicationController

  skip_before_filter :before_filter_set_current_user
  skip_before_filter :update_session_timeout, :only => :logout

  def new
  end

  def create
    pw = params[:login_session][:password]
    if @user = Member.authenticate(params[:login_session][:login], pw)
      session[:user_id] = @user.username
      redirect_to(session[:return_to] || member_path(@user))
      session[:return_to] = nil
    else
      flash.now[:error] = 'Invalid login.'
      render(:action => 'new')
    end
  end

  def destroy
    reset_session
    flash[:message] = 'Logged out.'
    redirect_to(home_path)
  end

end
