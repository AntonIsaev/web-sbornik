class RenameColumnInJournal < ActiveRecord::Migration
  def change
    rename_column 'journals', 'authors_rules_file_name', 'arules_file_name'
    rename_column 'journals', 'authors_rules_content_type', 'arules_content_type'
    rename_column 'journals', 'authors_rules_file_size', 'arules_file_size'
    rename_column 'journals', 'authors_rules_updated_at', 'arules_updated_at'
  end
end
