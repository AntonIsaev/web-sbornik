class AddContentsColumnToPortions < ActiveRecord::Migration
  def change
    add_column :portions, 'add_to_contents', :integer, default: 0
  end
end
