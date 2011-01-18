class CalendarsConferences < ActiveRecord::Migration

  def self.up
    create_table :calendars_conferences, :id => false do |t|
      t.integer :calendar_id
      t.integer :conference_id
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end

end
