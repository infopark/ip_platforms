class Conference < ActiveRecord::Base

  set_locking_column(:version)

  belongs_to(:creator, :class_name => 'Member')
  belongs_to(:series)
  has_and_belongs_to_many(:calendars)
  has_and_belongs_to_many(:categories)
  has_and_belongs_to_many(:participants, :class_name => 'Member')

  attr_accessor(:gps)

  attr_accessible(:accomodation)
  attr_accessible(:description)
  attr_accessible(:enddate)
  attr_accessible(:howtofind)
  attr_accessible(:location)
  attr_accessible(:name)
  attr_accessible(:startdtate)
  attr_accessible(:venue)
  attr_accessible(:serie_id)
  attr_accessible(:creator_id)
  attr_accessible(:gps)

  attr_readonly(:creator_id)

  validates(:accomodation, :length => { :maximum => 2000 })
  validates(:description, :presence => true, :length => { :maximum => 250 })
  validates(:enddate, :presence => true)
  validates(:howtofind, :length => { :maximum => 2000 })
  validates(:location, :length => { :maximum => 250 })
  validates(:name, :presence => true, :length => { :maximum => 100 })
  validates(:startdate, :presence => true)
  validates(:venue, :length => { :maximum => 2000 })
  validates(:gps, :format => {
    :with => %r{\d+(\.\d+)? ?[NnSs] ?,? ?\d+(\.\d+)? ?[EeWw]},
  })

  validate(:validate_startdate_before_enddate)

  def validate_startdate_before_enddate
  end

end
