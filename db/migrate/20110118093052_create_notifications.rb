class CreateNotifications < ActiveRecord::Migration

  def self.up
    create_table :notifications do |t|
      t.integer :member_id, :null => false
      t.string :content, :limit => 50, :null => false

      t.timestamps
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end

end
