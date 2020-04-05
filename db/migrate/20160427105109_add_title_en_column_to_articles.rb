class AddTitleEnColumnToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :title_en, :string
  end
end
