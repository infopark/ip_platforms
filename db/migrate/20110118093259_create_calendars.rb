class CreateCalendars < ActiveRecord::Migration
  def self.up
    create_table :calendars do |t|
      t.integer :member_id
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :calendars
  end
end
