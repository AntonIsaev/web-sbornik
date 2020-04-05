class AddChiefIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :chief_id, :integer, default: '0'
  end
end
