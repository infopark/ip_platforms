module ProfileHelper

  def is_my_profile?
    @user == @current_user
  end

  def show_details?
    is_my_profile? || @current_user.friends.exists?(@user)
  end
end
