class CreateArticlesAndAuthors < ActiveRecord::Migration
  def self.up
    create_table :articles_authors, id: false do |t|
      t.belongs_to :article, index: true
      t.belongs_to :author, index: true
      t.integer :itemorder
    end
  end  
  
  def self.down
    drop_table :articles_authors
  end
end
