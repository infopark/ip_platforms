class MembersController < ApplicationController
  append_before_filter :require_current_user,
                        :except => [:index, :show, :new, :create]
  append_before_filter :require_current_user_is_admin,
                        :only => [:destroy, :toggle_admin, :series, :remove_serie, :add_serie]

  helper_method :show_details?, :is_my_profile?,
                :is_friend?, :is_pending_friend?

  def index
    @q = params[:q]
    @state = params[:state]
    @location = params[:location]
    @members = Member.search(@q, @state, @current_user, @location).
        paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html
      format.xml  { render :xml => @members }
    end
  end

  def show
    @member = Member.find(params[:id])
    if show_details?
      @notifications = @member.notifications
      @friends = @member.friends
      @friend_requests_sent = @member.friend_requests_sent
      @friend_requests_received = @member.friend_requests_received
      @calendars = @member.calendars
    end

    respond_to do |format|
      format.html
      format.xml  { render :xml => @member }
    end
  end

  def new
    @member = Member.new

    respond_to do |format|
      format.html
      format.xml  { render :xml => @member }
    end
  end

  def edit
    @member = Member.find(params[:id])
    check_permissions || false
  end

  def create
    @member = Member.new(params[:member])
    @member.password = params[:password]

    respond_to do |format|
      if @member.save
        format.html {
          if logged_in?
            redirect_to(@member, :notice => 'Member was successfully created.')
          else
            session[:user_id] = @member.username
            redirect_to(member_path(@member))
          end
        }
        format.xml  { render :xml => @member, :status => :created, :location => @member }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @member.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @member = Member.find(params[:id])
    check_permissions || false

    respond_to do |format|
      if @member.update_attributes(params[:member])
        format.html { redirect_to(@member, :notice => 'Member was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @member.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @member = Member.find(params[:id])
    check_permissions || false
    @member.destroy

    respond_to do |format|
      format.html { redirect_to(members_url) }
      format.xml  { head :ok }
    end
  end

  def edit_password
    @member = Member.find(params[:id])
    if @member != @current_user and !is_admin?
      flash[:error] = 'Cannot change password for other users'
      redirect_to(home_path)
      return false
    end
    if request.post?
      raise 'password is blank' if params[:new_password].blank?
      if !is_admin? && !Member.authenticate(@current_user.username,
                                            params[:old_password])
        raise 'Old password does not match'
      end
      @member.change_password!(params[:new_password],
                               params[:new_password_confirm])
      flash[:notice] = 'Password edit successful'
      redirect_to(@member)
    end
  rescue => e
    flash.now[:error] = "Password edit failed: #{e}"
  end

  def toggle_admin
    @member = Member.find(params[:id])
    @member.admin = !@member.admin
    @member.save!
    flash[:notice] = "#{@member} is now #{"NOT" if !@member.admin} an admin"
    redirect_to(members_path)
  end

  def defriend
    begin
      @current_user.defriend(params[:id])
      flash[:notice] = 'Defriend request accepted'
    rescue => e
      flash[:error] = "Could not accept defriend request (#{e})"
    end
    redirect_to(@current_user)
  end

  def accept_rcd
    begin
      @current_user.accept_rcd(params[:id])
      flash[:notice] = 'Friend request accepted'
    rescue => e
      flash[:error] = "Could not accept friend request (#{e})"
    end
    redirect_to(@current_user)
  end

  def add_rcd
    begin
      @current_user.add_rcd(params[:id])
      flash[:notice] = 'Your friend request has been sent'
    rescue => e
      flash[:error] = "Could not send friend request (#{e})"
    end
    redirect_to(members_path)
  end

  def decline_rcd
    begin
      @current_user.decline_rcd(params[:id])
      flash[:notice] = 'Friend request declined'
    rescue => e
      flash[:error] = "Could not decline friend request (#{e})"
    end
    redirect_to(@current_user)
  end

  def revoke_rcd
    begin
      @current_user.revoke_rcd(params[:id])
      flash[:notice] = 'My friend request has been revoked'
    rescue => e
      flash[:error] = "Could not revoke friend my request (#{e})"
    end
    redirect_to(@current_user)
  end

  def series
    @member = Member.find(params[:id])
    @series = (Serie.all - @member.series)
  end

  def remove_serie
    member = Member.find(params[:id])
    member.series.delete(Serie.find(params[:serie_id]))
    member.save
    redirect_to series_member_path(@member), :notice => "Member has been successfully disassigned from the serie!"
  end

  def add_serie
    member = Member.find(params[:id])
    member.series << Serie.find(params[:serie_id])
    member.save
    redirect_to series_member_path(@member), :notice => "Member has been successfully made the official contact of the serie!"
  end

  private

  def check_permissions
    if @member != @current_user and !is_admin?
      flash[:error] = 'You only can change yourself!'
      redirect_to(home_path)
      return false
    end
  end

  def show_details?(user=@user)
    return false if !logged_in?
    return true if user && is_my_profile?
    return true if is_admin?
    is_friend?(user)
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

end
