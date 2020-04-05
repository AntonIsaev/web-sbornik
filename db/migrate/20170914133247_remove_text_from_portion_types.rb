class RemoveTextFromPortionTypes < ActiveRecord::Migration
  def change
    remove_column 'portion_types', 'portion_type', :string
  end
end
