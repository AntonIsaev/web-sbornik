class AddContentsColumnToPortionTypes < ActiveRecord::Migration
  def change
    add_column :portion_types, 'add_to_contents', :integer
  end
end
