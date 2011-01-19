class ApplicationController < ActionController::Base

  protect_from_forgery

  before_filter :before_filter_set_current_user
  before_filter :update_session_timeout

  helper_method :logged_in?, :is_admin?

  private

  def before_filter_set_current_user
    user_id = session[:user_id]
    @current_user =
      if user_id
        begin
          Member.find_by_username(user_id)
        rescue => e
          logger.error "can't set current user #{user_id}': #{e}"
          nil
        end
      end
    case
    when @current_user
      true
    when request.xhr?
      render(:text => 'unauthenticated_access_denied',
             :status => :forbidden)
      false
    end
  end

  def expire_session
    reset_session
    flash[:error] = 'Your session has expired. Please login again.'
    redirect_to new_login_session_path
  end

  def update_session_timeout
    expires_in = 60.minutes.from_now
    if session[:expires_at].blank?
      session[:expires_at] = expires_in
    else
      @time_left = (session[:expires_at].utc - Time.now.utc).to_i
      unless @time_left > 0
        session[:expires_at] = expires_in
        expire_session
      end
    end
  end

  def require_current_user
    return true if logged_in?
    session[:return_to] = request.fullpath
    flash[:error] = 'You need to login before you can access this page.'
    redirect_to(new_login_session_path)
    false
  end

  def require_current_user_is_admin
    return true if is_admin?
    raise 'You need administrative privileges for this page'
    false
  end

  def logged_in?
    !@current_user.blank?
  end

  def is_admin?
    logged_in? && @current_user.admin?
  end

end
