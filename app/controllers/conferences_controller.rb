class ConferencesController < ApplicationController
  before_filter :require_current_user, :except => [:index]
  before_filter :find_conference, :except => [:index, :new, :create]
  before_filter :require_creator_or_admin, :only => [:edit, :update, :destroy]

  # GET /conferences
  # GET /conferences.xml
  def index
    @qq = params[:qq]
    @q = params[:q]
    @category_ids = params[:category_ids]
    @start_at = (params[:start_at].to_date rescue nil) || Date.today
    @end_at = params[:end_at].to_date rescue nil
    if @end_at && @end_at < @start_at
      @end_at = @start_at
    end
    @location = params[:location]
    @conferences =
      if params[:submit] == 'Extended Search'
        Conference.extended_search(@qq, @current_user)
      else
        Conference.search(@q, @category_ids, @start_at, @end_at,
          @current_user, @location)
      end
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
      category_ids = params[:conference][:category_ids]
      old_categories = @conference.categories.dup
      if not category_ids.present? or category_ids == [""]
        if old_categories.any?
          @notify_creator = true
        end
        category_ids = []
      end
      @conference.categories = Category.find(category_ids)
      if @conference.update_attributes(params[:conference])
        format.html do
          if @notify_creator
            notification = Notification.new
            notification.member = @conference.creator
            notification.content = <<-EOS
              You're conference "#{@conference.name}" has been removed from "#{old_categories.map(&:name).join(',')}"
            EOS
            notification.save!
          end
          redirect_to(@conference, :notice => 'Conference was successfully updated.')
        end
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

  def require_creator_or_admin
    return true if is_admin?
    unless @conference.creator == @current_user
      session[:return_to] = request.fullpath
      flash[:error] = 'You need to be the creator of the conference to be able to change it'
      redirect_to :back
      false
    end
  end
end
