class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.integer :chief_id, default: 0
      t.integer :user_id_set, default: 0
      t.integer :user_id, default: 0
      t.integer :article_id, default: 0
      t.datetime :date_plan
      t.datetime :date_fact
      t.string :comment
      t.integer :score, default: 0

      t.timestamps null: false
    end
  end
end
