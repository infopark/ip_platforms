class CreateNotifications < ActiveRecord::Migration

  def self.up
    create_table :notifications do |t|
      t.integer :member_id
      t.string :content

      t.timestamps
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end

end
