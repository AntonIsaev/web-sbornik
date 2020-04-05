class AddNameInContentsColumnToPortions < ActiveRecord::Migration
  def change
    add_column :portions, 'name_in_contents', :string, default: ""
  end
end
