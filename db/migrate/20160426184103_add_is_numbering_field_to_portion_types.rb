class AddIsNumberingFieldToPortionTypes < ActiveRecord::Migration
  def change
    add_column :portion_types, :is_numbering, :integer
  end
end
