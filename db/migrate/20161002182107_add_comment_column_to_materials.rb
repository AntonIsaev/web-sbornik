class AddCommentColumnToMaterials < ActiveRecord::Migration
  def change
    add_column :materials, :comment, :text
  end
end
