class CreateConferences < ActiveRecord::Migration
  def self.up
    create_table :conferences do |t|
      t.integer :version
      t.string :name
      t.integer :creator_id
      t.integer :series_id
      t.date :startdate
      t.date :enddate
      t.string :description
      t.string :location
      t.string :gps
      t.string :venue
      t.string :accomodation
      t.string :howtofind

      t.timestamps
    end
  end

  def self.down
    drop_table :conferences
  end
end
