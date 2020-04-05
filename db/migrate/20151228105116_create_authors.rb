class CreateAuthors < ActiveRecord::Migration
  def self.up
    create_table :authors do |t|
      t.string :surname
      t.string :mainname
      t.string :middlename
      t.string :shortname
      t.string :shortnameen
      t.string :email
      t.string :moretext

      t.timestamps null: false
    end
  end
  
  def self.down
    drop_table :authors
  end
end
