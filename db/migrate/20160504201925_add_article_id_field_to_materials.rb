class AddArticleIdFieldToMaterials < ActiveRecord::Migration
  def change
    add_column :materials, :article_id, :integer
  end
end
