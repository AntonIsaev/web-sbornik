class CreateDegrees < ActiveRecord::Migration
  def change
    create_table :degrees do |t|
      t.belongs_to :author, index: true
      t.belongs_to :institution, index: true
      t.string :info
      t.timestamps null: false
    end
  end
end
