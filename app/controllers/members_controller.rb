class MembersController < ApplicationController
  append_before_filter :require_current_user, :except => :index
  append_before_filter :require_current_user_is_admin,
                        :only => [:edit, :new, :create, :update, :destroy]

  def index
    @q = params[:q]
    @state = params[:state]
    @location = params[:location]
    @members = @current_user.search_members(@q, @state, @location)

    respond_to do |format|
      format.html
      format.xml  { render :xml => @members }
    end
  end

  def show
    @member = Member.find(params[:id])
    @notifications = @member.notifications
    @friends = @member.friends
    @friend_requests_sent = @member.friend_requests_sent
    @friend_requests_received = @member.friend_requests_received
    @calendars = @member.calendars

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
  end

  def create
    @member = Member.new(params[:member])

    respond_to do |format|
      if @member.save
        format.html { redirect_to(@member, :notice => 'Member was successfully created.') }
        format.xml  { render :xml => @member, :status => :created, :location => @member }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @member.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @member = Member.find(params[:id])

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
    redirect_to(@current_user)
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


end
