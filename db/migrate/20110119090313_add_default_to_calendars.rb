class AddDefaultToCalendars < ActiveRecord::Migration
  def self.up
    add_column :calendars, :is_default, :boolean
  end

  def self.down
    remove_column :calendars, :is_default
  end
end
