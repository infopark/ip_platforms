class Category < ActiveRecord::Base

  set_locking_column(:version)

  belongs_to(:parent, :class_name => 'Category')
  has_and_belongs_to_many(:conferences)
  has_many(:children, :class_name => 'Category', :foreign_key => :parent_id,
          :dependent => :nullify)

end
