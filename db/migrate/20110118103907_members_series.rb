class MembersSeries < ActiveRecord::Migration

  def self.up
    create_table :members_series, :id => false do |t|
      t.integer :member_id
      t.integer :serie_id
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end

end
