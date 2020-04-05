class RemoveCommentIdColumnFromCommentTypes < ActiveRecord::Migration
  def change
    remove_column 'comment_types', 'comment_id'
  end
end
