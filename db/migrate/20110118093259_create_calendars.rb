class CreateCalendars < ActiveRecord::Migration

  def self.up
    create_table :calendars do |t|
      t.integer :member_id, :null => false
      t.string :name, :limit => 50

      t.timestamps
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end

end
