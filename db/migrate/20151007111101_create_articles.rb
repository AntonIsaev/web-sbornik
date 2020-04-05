class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.string :title
      t.text :text
      t.integer :annotation_in_eng

      t.timestamps null: false
    end
  end

  def self.down
    drop_table :articles
  end
end
