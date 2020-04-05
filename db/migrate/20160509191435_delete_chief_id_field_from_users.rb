class DeleteChiefIdFieldFromUsers < ActiveRecord::Migration
  def change
    remove_column 'users', 'chief_id'
  end
end
