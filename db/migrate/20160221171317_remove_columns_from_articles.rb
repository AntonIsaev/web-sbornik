class RemoveColumnsFromArticles < ActiveRecord::Migration
  def change
    remove_column 'articles', 'text'
    remove_column 'articles', 'annotation_in_eng'
  end
end
