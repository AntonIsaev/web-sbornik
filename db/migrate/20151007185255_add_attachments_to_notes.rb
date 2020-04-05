class AddAttachmentsToNotes < ActiveRecord::Migration
  def up
    add_attachment :comments, :file
  end

  def down
    remove_attachment :comments, :file
  end
end
