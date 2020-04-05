class CreateUroles < ActiveRecord::Migration
  def change
    create_table :uroles do |t|
      t.integer :chief_id
      t.string :email
      t.integer :user_id
      t.integer :publication_id
      t.integer :role_id

      t.timestamps null: false
    end
  end
end
