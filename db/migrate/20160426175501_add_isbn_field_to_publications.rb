class AddIsbnFieldToPublications < ActiveRecord::Migration
  def change
    add_column :publications, :ISBN, :string, default: ""
  end
end
