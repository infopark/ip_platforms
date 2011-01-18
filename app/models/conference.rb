class Conference < ActiveRecord::Base

  set_locking_column(:version)

  belongs_to(:creator, :class_name => 'Member')
  belongs_to(:series)
  has_and_belongs_to_many(:calendars)
  has_and_belongs_to_many(:categories)
  has_and_belongs_to_many(:participants, :class_name => 'Member')

end
