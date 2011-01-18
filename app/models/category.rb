class Category < ActiveRecord::Base

  include BaseRecord

  MAX_TREE_DEPTH = 10

  set_locking_column(:version)

  belongs_to(:parent, :class_name => 'Category')
  has_and_belongs_to_many(:conferences)
  has_many(:children, :class_name => 'Category', :foreign_key => :parent_id,
          :dependent => :nullify)

  attr_accessible(:parent_id)
  attr_accessible(:name)

  validates(:name, :presence => true, :length => { :maximum => 50 })
  validate :validate_parent_not_cyclic

  private

  def validate_parent_not_cyclic
    if ancestor_of?(parent)
      errors.add('parent', "relationship cannot be cyclic or deeper than #{MAX_TREE_DEPTH}")
    end
  end

  def ancestor_of?(other, max_recursion = MAX_TREE_DEPTH)
    return false if other.nil?
    return true if max_recursion < 1
    other == self || ancestor_of?(other.parent, max_recursion - 1)
  end
end
