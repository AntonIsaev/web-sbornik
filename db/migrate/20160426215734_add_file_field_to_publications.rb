class AddFileFieldToPublications < ActiveRecord::Migration
  def change
    add_attachment :publications, :file
  end
end
