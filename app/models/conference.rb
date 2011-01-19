class Conference < ActiveRecord::Base

  include BaseRecord
  include GpsLocation

  acts_as_mappable

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

  def self.search(q, category_ids, start_at, end_at, member, location)
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
      s = category_ids.map {|i| (i.to_i rescue 0)}.join(',')
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
    qq.to_s.split(/\s+/).each do |s|
      case s
      when /\Afrom:(.*)/
        start_at = ($1.to_date rescue nil)
      when /\Auntil:(.*)/
        end_at = ($1.to_date rescue nil)
      when 'opt:withsub'
        # ignore
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
    search(q.join(' '), category_ids.compact.map(&:id),
        start_at, end_at, member, location)
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
