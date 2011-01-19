class AddCategoryIdToCalendars < ActiveRecord::Migration
  def self.up
    add_column :calendars, :category_id, :integer
  end

  def self.down
    remove_column :calendars, :category_id
  end
end
