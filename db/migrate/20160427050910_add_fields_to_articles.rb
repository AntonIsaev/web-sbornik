class AddFieldsToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :udk, :string
    add_column :articles, :annotation, :text
    add_column :articles, :annotation_en, :text
    add_column :articles, :keywords, :string
    add_column :articles, :keywords_en, :string
  end
end
