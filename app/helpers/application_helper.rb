module ApplicationHelper

  def page_title
    "Infopark CaP | #{controller.controller_name.humanize}"
  end

  def login_logout_link
    if logged_in?
      link_to('My profile',
              member_path(@current_user)) << " | " <<
      link_to("Logout #{@current_user.fullname} (#{@current_user})",
              login_session_path, :method => :delete)
    else
      link_to('Register New User', new_member_path) << " | " <<
      link_to('Login', new_login_session_path)

    end
  end

  def link_to_profile(title)
    link_to title, member_path(@current_user)
  end

end
