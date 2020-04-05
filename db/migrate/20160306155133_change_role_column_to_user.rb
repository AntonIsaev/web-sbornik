class ChangeRoleColumnToUser < ActiveRecord::Migration
  def change
    rename_column 'users', 'roles_mask', 'role_id'
    
  end
end
