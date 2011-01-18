class MembersController < ApplicationController
  # TODO: Only show page für andere members, other requires login

  def index
    @members = Member.all

    respond_to do |format|
      format.html
      format.xml  { render :xml => @members }
    end
  end

  def show
    @member = Member.find(params[:id])

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
      if params[:new_password] != params[:new_password_confirm]
        raise 'password does not match confirmation'
      end
      if is_admin?
        @member.password=params[:new_password]
        @member.save!
      else
        @member.change_password!(params[:old_password], params[:new_password])
      end
      flash[:notice] = 'Password edit successful'
      if @member == @current_user
        redirect_to(profile_path)
      else
        redirect_to(@member)
      end
    end
  rescue => e
    flash.now[:error] = "Password edit failed: #{e}"
  end

end
