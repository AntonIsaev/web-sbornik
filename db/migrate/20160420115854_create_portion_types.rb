class CreatePortionTypes < ActiveRecord::Migration
  def change
    create_table :portion_types do |t|
      t.string :portion_type
      t.references :portion, index: true

      t.timestamps null: false
    end
  end
end
