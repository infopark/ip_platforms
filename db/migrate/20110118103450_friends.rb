class Friends < ActiveRecord::Migration

  def self.up
    create_table :friends, :id => false do |t|
      t.integer :member_id
      t.integer :friend_id
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end

end
