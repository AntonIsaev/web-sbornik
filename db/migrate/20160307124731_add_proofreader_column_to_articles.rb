class AddProofreaderColumnToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :proofreader_id, :integer
  end
end
