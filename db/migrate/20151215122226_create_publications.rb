class CreatePublications < ActiveRecord::Migration
  def change
    create_table :publications do |t|
      t.integer :pubno
      t.string :pubtxt
      t.references :journal, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
