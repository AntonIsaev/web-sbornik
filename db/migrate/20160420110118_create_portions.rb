class CreatePortions < ActiveRecord::Migration
  def change
    create_table :portions do |t|
      t.integer :ftype
      t.integer :position
      t.integer :publication_id
      t.timestamps null: false
    end
    
    add_attachment :portions, :file 
  end
end
