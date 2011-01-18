class ConferencesController < ApplicationController
  before_filter :require_current_user, :except => [:index]
  before_filter :find_conference, :except => [:index, :new, :create]
  before_filter :require_creator, :only => [:edit, :update, :destroy]

  # GET /conferences
  # GET /conferences.xml
  def index
    @q = params[:q]
    @categories = params[:categories]
    @start_at = params[:start_at]
    @end_at = params[:end_at]
    @location = params[:location]
    @conferences = Conference.search(@q, @categories, @start_at, @end_at,
        @current_user, @location)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @conferences }
    end
  end

  # GET /conferences/1
  # GET /conferences/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @conference }
    end
  end

  # GET /conferences/new
  # GET /conferences/new.xml
  def new
    @conference = Conference.new
    @categories = Category.order.all
    @series = @current_user.series
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @conference }
    end
  end

  def edit
    @categories = Category.order.all
    @series = @current_user.series
  end

  def create
    @conference = Conference.new(params[:conference])
    @conference.creator = @current_user
    @conference.categories = Category.find(params[:conference][:category_ids] || [])
    @conference.serie = Serie.find(params[:conference][:serie_id]) if params[:conference][:serie_id]
    @categories = Category.all
    @series = @current_user.series

    respond_to do |format|
      if @conference.save
        format.html { redirect_to(@conference, :notice => 'Conference was successfully created.') }
        format.xml  { render :xml => @conference, :status => :created, :location => @conference }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @conference.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /conferences/1
  # PUT /conferences/1.xml
  def update
    @categories = Category.all
    @series = @current_user.series
    respond_to do |format|
      if @conference.update_attributes(params[:conference])
        format.html { redirect_to(@conference, :notice => 'Conference was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @conference.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /conferences/1
  # DELETE /conferences/1.xml
  def destroy
    @conference.destroy
    respond_to do |format|
      format.html { redirect_to(conferences_url) }
      format.xml  { head :ok }
    end
  end

  def signup
    respond_to do |format|
      @conference.participants << @current_user
      @conference.save
      format.html { redirect_to(@conference, :notice => "You've been assigned to this conference!") }
    end
  end

  def signout
    respond_to do |format|
      @conference.participants.delete(@current_user)
      @conference.save
      format.html { redirect_to(@conference, :notice => "You've been signed out from this conference!") }
    end
  end

  def invite
    respond_to do |format|
      friend = Member.find(params[:friend_id])
      if friend.friends.include?(@current_user)
        format.html do
          flash[:notice] = "User #{friend.username} has been invited to this conference!"
          notification = Notification.new(
            :content => "Invited to <a href='#{conference_path(@conference)}'>#{@conference.name}</a>" \
              " by <a href='#{member_path(@current_user)}'>#{@current_user.fullname}</a>"
          )
          notification.member = friend
          notification.save!
          redirect_to(@conference)
        end
      end
    end
  end

  private

  def find_conference
    @conference = Conference.find(params[:id])
  end

  def require_creator
    unless @conference.creator == @current_user
      session[:return_to] = request.fullpath
      flash[:error] = 'You need to be the creator of the conference to be able to change it'
      redirect_to :back
      false
    end
  end
end
