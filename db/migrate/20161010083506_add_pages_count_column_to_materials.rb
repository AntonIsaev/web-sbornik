class AddPagesCountColumnToMaterials < ActiveRecord::Migration
  def change
    add_column :materials, :pages_count, :integer, default: 0
  end
end
