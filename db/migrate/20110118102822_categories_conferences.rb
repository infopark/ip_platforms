class CategoriesConferences < ActiveRecord::Migration

  def self.up
    create_table :categories_conferences, :id => false do |t|
      t.integer :category_id
      t.integer :conference_id
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end

end
