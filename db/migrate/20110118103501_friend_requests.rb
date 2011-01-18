class FriendRequests < ActiveRecord::Migration

  def self.up
    create_table :friend_requests, :id => false do |t|
      t.integer :member_id
      t.integer :requestee_id
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end

end
