class CreateCommentTypes < ActiveRecord::Migration
  def change
    create_table :comment_types do |t|
      t.string :comment_type
      t.references :comment, index: true

      t.timestamps null: false
    end
  end
end
