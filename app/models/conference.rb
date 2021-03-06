class Conference < ActiveRecord::Base

  include BaseRecord
  include GpsLocation
  include Icalendar

  set_locking_column(:version)

  belongs_to(:creator, :class_name => 'Member')
  belongs_to(:serie)
  has_and_belongs_to_many(:calendars)
  has_and_belongs_to_many(:categories)
  has_and_belongs_to_many(:participants, :class_name => 'Member')

  attr_accessible(:accomodation)
  attr_accessible(:description)
  attr_accessible(:enddate)
  attr_accessible(:howtofind)
  attr_accessible(:location)
  attr_accessible(:name)
  attr_accessible(:startdate)
  attr_accessible(:venue)
  attr_accessible(:serie_id)
  attr_accessible(:creator_id)
  attr_accessible(:version)

  attr_readonly(:creator_id)

  validates(:accomodation, :length => { :maximum => 2000 })
  validates(:description, :presence => true, :length => { :maximum => 2000 })
  validates(:enddate, :presence => true)
  validates(:howtofind, :length => { :maximum => 2000 })
  validates(:location, :length => { :maximum => 250 })
  validates(:name, :presence => true, :length => { :maximum => 100 })
  validates(:startdate, :presence => true)
  validates(:venue, :length => { :maximum => 2000 })

  validate(:validate_enddate_before_startdate)

  before_validation(:set_enddate_if_blank_before_validation)

  after_save :notify_on_datechange

  def validate_enddate_before_startdate
    if startdate && enddate && startdate > enddate
      errors.add(:enddate, :must_not_be_earlier_than_startdate)
    end
  end

  def set_enddate_if_blank_before_validation
    enddate = startdate if enddate.blank?
  end

  def self.search(q, category_ids, withsub, start_at, end_at, member, location)
    r = self
    if c = multiword_text_filter_conditions(q, :name, :description)
      r = r.where(c)
    end
    if start_at
      r = r.where(['enddate >= ?', start_at])
    else
      r = r.where(['enddate >= ?', Date.today])
    end
    if end_at
      r = r.where(['startdate <= ?', end_at])
    end
    if member && member.has_gps_data?
      location = location.to_s.to_i
      if 50 <= location && location <= 5000
        r = r.where(["SQRT(POW(ABS(?-lat),2)+POW(ABS(?-lng),2)) < ?",
            member.lat, member.lng, location.to_f/100])
      end
    end
    unless category_ids.blank?
      category_ids = category_ids.map {|i| (i.to_i rescue 0)}
      if withsub
        category_ids = Category.expand_children(category_ids)
      end
      s = category_ids.to_a.join(',')
      r = r.where("id IN (SELECT conference_id FROM categories_conferences " \
          "WHERE category_id IN (#{s}))")
    end
    r.all
  end

  def self.extended_search(qq, member)
    q = []
    category_ids = []
    start_at = nil
    end_at = nil
    location = nil
    withsub = false
    qq.to_s.split(/\s+/).each do |s|
      case s
      when /\Afrom:(.*)/
        start_at = ($1.to_date rescue nil)
      when /\Auntil:(.*)/
        end_at = ($1.to_date rescue nil)
      when 'opt:withsub'
        withsub = true
      when 'reg:country'
        # ignore
      when /\Areg:(.*)/
        location = $1.to_i
      when /\Acat:(.*)/
        category_ids << Category.find_by_name($1)
      else
        q << s
      end
    end
    search(q.join(' '), category_ids.compact.map(&:id), withsub,
        start_at, end_at, member, location)
  end

  def ical(conference_url=nil, attendees=[])
    cal = Calendar.new
    cal.custom_property("METHOD", "PUBLISH")
    event = Icalendar::Event.new
    event.start = self.startdate
    event.end = self.enddate + 1.day
    event.summary = self.name
    event.location = self.venue
    event.organizer = self.creator.fullname
    event.description = self.description
    attendees.each {|a| event.add_attendee a}
    if self.lat && self.lng
      event.geo = Icalendar::Geo.new("%.06f"%self.lat, "%.06f"%self.lng.to_s)
    end
    event.url = conference_url if conference_url
    cal.add event
    cal.publish
    cal.to_ical
  end

  private

  def notify_on_datechange
    unless self.changes[:startdate].blank?
      self.participants.each do |p|
        p.notifications.create(:content => "The startdate of conference " +
                               "#{self.name} has changed to #{self.startdate}")
      end
    end
    unless self.changes[:enddate].blank?
      self.participants.each do |p|
        p.notifications.create(:content => "The enddate of conference " +
                               "#{self.name} has changed to #{self.enddate}")
      end
    end
    return true
  end

end
