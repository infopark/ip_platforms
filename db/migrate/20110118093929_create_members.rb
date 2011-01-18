class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.integer :version
      t.string :username
      t.string :password_hash
      t.string :password_salt
      t.string :fullname
      t.string :email
      t.string :town
      t.string :country
      t.string :gps
      t.boolean :admin

      t.timestamps
    end
  end

  def self.down
    drop_table :members
  end
end
