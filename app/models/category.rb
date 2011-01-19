class Category < ActiveRecord::Base

  include BaseRecord

  MAX_TREE_DEPTH = 10

  set_locking_column(:version)

  belongs_to(:parent, :class_name => 'Category')
  has_and_belongs_to_many(:conferences)
  has_many(:calendars)
  has_many(:children, :class_name => 'Category', :foreign_key => :parent_id,
          :dependent => :nullify)

  attr_accessible(:parent_id)
  attr_accessible(:name)

  validates(:name, :presence => true, :length => { :maximum => 50 },
      :format => { :with => /\A[-\w\d_]+\Z/ })
  validate :validate_parent_not_cyclic

  def self_and_all_children
    collection = [self]
    if self.children.any?
      children.each do |child|
        collection += child.self_and_all_children
      end
    end
    collection
  end

  private

  def validate_parent_not_cyclic
    if ancestor_of?(parent)
      errors.add('parent',
          "relationship cannot be cyclic or deeper than #{MAX_TREE_DEPTH}")
    end
  end

  def ancestor_of?(other, max_recursion = MAX_TREE_DEPTH)
    return false if other.nil?
    return true if max_recursion < 1
    other == self || ancestor_of?(other.parent, max_recursion - 1)
  end

end
