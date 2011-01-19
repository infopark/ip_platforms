class ConferencesController < ApplicationController
  before_filter :require_current_user, :except => [:index]
  before_filter :find_conference, :except => [:index, :new, :create,
                                              :geocode_address]
  before_filter :require_creator_or_admin, :only => [:edit, :update, :destroy]

  helper_method :show_details?

  def index
    @qq = params[:qq]
    @q = params[:q]
    @category_ids = params[:category_ids]
    @withsub = params[:withsub]
    @start_at = (params[:start_at].to_date rescue nil) || Date.today
    @end_at = params[:end_at].to_date rescue nil
    if @end_at && @end_at < @start_at
      @end_at = @start_at
    end
    @location = params[:location]
    @conferences =
      if params[:commit] == 'Extended Search'
        Conference.extended_search(@qq, @current_user)
      else
        Conference.search(@q, @category_ids, @withsub,
            @start_at, @end_at, @current_user, @location)
      end
    respond_to do |format|
      format.html do
        @conferences = @conferences.paginate(:page => params[:page], :per_page => 15)
      end
      format.xml  { render :xml => @conferences }
    end
  end

  def show
    @my_url = url_for(@conference)
    @calendars = @current_user.calendars
    respond_to do |format|
      format.html
      format.rss  {
        render :rss => @conference
      }
      format.xml  { render :xml => @conference }
      format.ics do
        attendees= []
        if params[:with_attendees]
          @conference.participants.each do |p|
            if show_details?(@conference, p)
              attendees << "MAILTO:#{p.email}"
            else
              attendees << "CN=#{p.username}"
            end
          end
        end
        render :text => @conference.ical(@my_url, attendees)
      end
      format.pdf {
        image_path = File.join(Rails.public_path, 'images')
        @with_attendees = params[:with_attendees]
        prawnto :prawn => {:page_layout => :portrait,
                           :page_size => 'A4',
                           :top_margin => 85,
                           :left_margin => 85,
                           :right_margin => 10,
                           :bottom_margin => 10,
                           :background => "#{image_path}/iplogo.png"}
        render :layout => false
      }
    end
  end

  def new
    @conference = Conference.new
    @categories = Category.order.all
    @series = @current_user.series
    respond_to do |format|
      format.html
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

  def update
    @categories = Category.all
    @series = @current_user.series
    respond_to do |format|
      category_ids = params[:conference][:category_ids]
      old_categories = @conference.categories.dup
      if not category_ids.present? or category_ids == [""]
        category_ids = []
      end
      @conference.categories = Category.find(category_ids)
      if @conference.update_attributes(params[:conference])
        format.html do
        deleted_categories = old_categories - @conference.categories
          if deleted_categories
            @conference.creator.notifications.create(:content => "Your " +
                "conference '#{@conference.name}' has been removed from " +
                deleted_categories.map(&:name).join(', '))
          end

          redirect_to(@conference,
                      :notice => 'Conference was successfully updated.')
        end
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @conference.errors, :status => :unprocessable_entity }
      end
    end
  end

  def geocode_address
    if request.xhr? && params[:q]
      r = Geokit::Geocoders::GoogleGeocoder.geocode(params[:q])
      latlng = ''
      latlng += (r.lat > 0 ? "#{r.lat}N," : "#{-r.lat}S,") unless r.lat.blank?
      latlng += (r.lng > 0 ? "#{r.lng}E" : "#{-r.lng}W") unless r.lng.blank?
      render(:json => {:latlng => latlng})
    else
      render(:text => 'I like to be called right', :status => 403)
    end
  end

  def add_to_calendar
    @calendar = @current_user.calendars.find(params[:calendar_id])
    @calendar.conferences << @conference
    respond_to do |format|
      format.html do
        if @calendar.save
          redirect_to @conference, :notice => "Conference has been successfully added to calendar!"
        else
          redirect_to @conference, :notice => "Conference couldn't be added to the calendar!"
        end
      end
    end
  end

  def remove_from_calendar
    @calendar = Calendar.find(params[:calendar_id])
    @calendar.conferences.delete(@conference)
    respond_to do |format|
      format.html do
        if @calendar.save
          redirect_to @calendar, :notice => "Conference has been successfully removed from calendar!"
        else
          redirect_to @calendar, :notice => "Conference couldn't be removed from the calendar!"
        end
      end
    end
  end

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

  def show_details?(conference, participant, current_user=@current_user)
    conference.creator == current_user or
      current_user.friends.include?(participant) or
      current_user == participant
  end

end
