class Serie < ActiveRecord::Base

  set_locking_column(:version)

  has_and_belongs_to_many(:contacts, :class_name => 'Member')
  has_many(:conferences)

  attr_accessible(:name)

  validates(:name, :presence => true, :length => { :maximum => 80 })

end
