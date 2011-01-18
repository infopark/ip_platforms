class CreateSeries < ActiveRecord::Migration

  def self.up
    create_table :series do |t|
      t.integer :version
      t.string :name

      t.timestamps
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end

end