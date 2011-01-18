class Notification < ActiveRecord::Base

  include BaseRecord

  belongs_to(:member)

  attr_accessible(:member_id)
  attr_accessible(:content)

  validates(:member_id, :presence => true)
  validates(:content, :presence => true, :length => { :maximum => 50 })

  attr_readonly(:member_id)
  attr_readonly(:content)

end
