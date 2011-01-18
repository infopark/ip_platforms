class Serie < ActiveRecord::Base

  set_locking_column(:version)

  has_and_belongs_to_many(:contacts, :class_name => 'Member')
  has_many(:conferences)

end
