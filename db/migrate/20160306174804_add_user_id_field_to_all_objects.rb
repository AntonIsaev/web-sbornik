class AddUserIdFieldToAllObjects < ActiveRecord::Migration
  def change
    add_column :journals, :user_id, :integer, default: '0'
    add_column :publications, :user_id, :integer, default: '0'
    add_column :articles, :user_id, :integer, default: '0'
    add_column :authors, :user_id, :integer, default: '0'
    add_column :comments, :user_id, :integer, default: '0'
    add_column :degrees, :user_id, :integer, default: '0'
    add_column :institutions, :user_id, :integer, default: '0'
    add_column :paternities, :user_id, :integer, default: '0'
  end
end
