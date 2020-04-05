class AddPublicationIdColumnToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :publication_id, :integer
  end
end
