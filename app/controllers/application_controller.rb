class ApplicationController < ActionController::Base

  protect_from_forgery

  before_filter :before_filter_set_current_user

  helper_method :logged_in?

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

  def require_current_user
    unless logged_in?
      session[:return_to] = request.fullpath
      flash[:error] = 'You need to login before you can access this page.'
      redirect_to(new_login_session_path)
      false
    end
  end

  def logged_in?
    !session[:user_id].blank?
  end

end
