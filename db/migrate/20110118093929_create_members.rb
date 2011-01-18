class CreateMembers < ActiveRecord::Migration

  def self.up
    create_table :members do |t|
      t.integer :version
      t.string :username, :limit => 50, :null => false
      t.string :password_hash, :limit => 64
      t.string :password_salt, :limit => 12
      t.string :fullname, :limit => 100
      t.string :email, :limit => 250
      t.string :town, :limit => 100
      t.string :country, :limit => 100
      t.decimal :lat, :precision => 15, :scale => 10
      t.decimal :lng, :precision => 15, :scale => 10
      t.boolean :admin, :null => false, :default => 0

      t.timestamps
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end

end
