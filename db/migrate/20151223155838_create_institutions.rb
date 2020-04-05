class CreateInstitutions < ActiveRecord::Migration
  def change
    create_table :institutions do |t|
      t.string :title
      t.string :postaddress
      t.string :webaddress

      t.timestamps null: false
    end
  end
end
