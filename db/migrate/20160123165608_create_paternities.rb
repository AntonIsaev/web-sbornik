class CreatePaternities < ActiveRecord::Migration
  def change
    drop_table :articles_authors
    create_table :paternities do |t|
      t.belongs_to :article
      t.belongs_to :author
      t.integer :position

      t.timestamps null: false
    end
  end
end
