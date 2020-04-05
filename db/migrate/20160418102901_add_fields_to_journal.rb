class AddFieldsToJournal < ActiveRecord::Migration
  def change
    remove_column 'journals', 'subtitle'
    add_column :journals, :udk, :string
    add_column :journals, :website, :string
    add_column :journals, :editorial_board, :text
    add_attachment :journals, :authors_rules
    add_attachment :journals, :logo
  end
end
