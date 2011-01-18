class CreateCategories < ActiveRecord::Migration

  def self.up
    create_table :categories do |t|
      t.integer :version
      t.string :name
      t.integer :parent_id

      t.timestamps
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end

end
