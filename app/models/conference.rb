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

  def validate_enddate_before_startdate
    if startdate && enddate && startdate > enddate
      errors.add(:enddate, :must_not_be_earlier_than_startdate)
    end
  end

  def set_enddate_if_blank_before_validation
    enddate = startdate if enddate.blank?
  end

  def self.search(q, categories, start_at, end_at, member, location)
    r = Conference
    if c = text_filter_conditions(q, :name, :description)
      r = r.where(c)
    end
    r.all
  end

end
