class RemoveUserIdFieldFromPublications < ActiveRecord::Migration
  def change
    remove_column 'publications', 'user_id'
  end
end
