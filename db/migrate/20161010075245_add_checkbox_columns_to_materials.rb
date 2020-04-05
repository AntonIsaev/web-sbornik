class AddCheckboxColumnsToMaterials < ActiveRecord::Migration
  def change
    add_column :materials, :is_bibliography_ready, :integer, default: 0
    add_column :materials, :is_images_ready, :integer, default: 0
    add_column :materials, :is_formulas_ready, :integer, default: 0
  end
end
