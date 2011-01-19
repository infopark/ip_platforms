class Calendar < ActiveRecord::Base

  include BaseRecord

  belongs_to(:category)
  belongs_to(:member)
  has_and_belongs_to_many(:conferences)

  attr_accessible(:member_id)
  attr_accessible(:name)

  attr_readonly(:member_id)

  validates(:name, :presence => true)
  validates(:name, :length => { :maximum => 50 })

  alias_method :conferences_orig, :conferences

  def conferences
    return conferences_for_category if category
    conferences_orig
  end

  private

  def conferences_for_category
    member.default_calendar.conferences.reject do |conference|
      ((category.self_and_all_children) & conference.categories).empty?
    end
  end

end
