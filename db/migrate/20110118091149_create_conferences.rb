class CreateConferences < ActiveRecord::Migration

  def self.up
    create_table :conferences do |t|
      t.integer :version
      t.string :name, :limit => 100, :null => false
      t.integer :creator_id
      t.integer :serie_id
      t.date :startdate, :null => false
      t.date :enddate, :null => false
      t.string :description, :limit => 2000, :null => false
      t.string :location, :limit => 250
      t.decimal :lat, :precision => 15, :scale => 10
      t.decimal :lng, :precision => 15, :scale => 10
      t.string :venue, :limit => 2000
      t.string :accomodation, :limit => 2000
      t.string :howtofind, :limit => 2000

      t.timestamps
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end

end
