class CreateHelpTopics < ActiveRecord::Migration
  def change
    create_table :help_topics do |t|
      t.string :for_item
      t.string :title
      t.string :short_text
      t.text :long_text
      t.integer :parent_id, default: 0
      t.integer :neighbour_id, default: 0
      t.integer :shows_count, default: 0
      t.integer :shows_count_mini, default: 0

      t.timestamps null: false
    end
  end
end
