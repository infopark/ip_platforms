class Serie < ActiveRecord::Base

  include BaseRecord

  set_locking_column(:version)

  has_and_belongs_to_many(:contacts, :class_name => 'Member')
  has_many(:conferences)

  attr_accessible(:name)
  attr_accessible(:description)
  attr_accessible(:url)

  validates(:name, :presence => true,
      :uniqueness => true,
      :length => { :maximum => 80 })
  validates_length_of(:description, :maximum => 2000, :allow_blank => true)
  validates_length_of(:url, :maximum => 250, :allow_blank => true)

end
