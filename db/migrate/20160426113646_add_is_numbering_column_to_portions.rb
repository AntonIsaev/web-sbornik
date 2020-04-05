class AddIsNumberingColumnToPortions < ActiveRecord::Migration
  def change
    add_column :portions, :is_numbering, :integer, default: 0
  end
end
