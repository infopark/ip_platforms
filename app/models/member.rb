class Member < ActiveRecord::Base

  set_locking_column(:version)

  has_and_belongs_to_many(:friend_requests, :class_name => 'Member',
      :join_table => 'friend_requests', :foreign_key => :requestee_id)
  has_and_belongs_to_many(:friends, :class_name => 'Member',
      :join_table => 'friends', :foreign_key => :friend_id)
  has_and_belongs_to_many(:participations, :class_name => 'Conference')
  has_and_belongs_to_many(:series)
  has_many(:calendars)
  has_many(:conferences, :foreign_key => :creator_id)

end
