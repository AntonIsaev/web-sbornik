class AddIssnFieldToJournals < ActiveRecord::Migration
  def change
    add_column :journals, :ISSN, :string, default: ""
  end
end
