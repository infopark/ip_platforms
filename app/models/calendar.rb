class Calendar < ActiveRecord::Base

  belongs_to(:member)
  has_and_belongs_to_many(:conferences)

end
