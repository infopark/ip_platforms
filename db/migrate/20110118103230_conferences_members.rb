class ConferencesMembers < ActiveRecord::Migration

  def self.up
    create_table :conferences_members, :id => false do |t|
      t.integer :conference_id
      t.integer :member_id
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end

end
