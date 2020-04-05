class RemovePortionIdColumnFromPortionTypes < ActiveRecord::Migration
  def change
    remove_column 'portion_types', 'portion_id'
  end
end
