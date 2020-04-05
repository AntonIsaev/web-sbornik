class CreateMaterials < ActiveRecord::Migration
  def change
    create_table :materials do |t|
      t.attachment :file
      t.integer :checked_by_chief_id, default: 0
      t.integer :checked_by_chief_assistant_id, default: 0
      t.integer :checked_by_proofreader_id, default: 0
      t.integer :checked_by_author_id, default: 0
      t.integer :position

      t.timestamps null: false
    end
  end
end
