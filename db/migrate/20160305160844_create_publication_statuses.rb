class CreatePublicationStatuses < ActiveRecord::Migration
  def change
    create_table :publication_statuses do |t|
      t.string :title
      t.integer :order_id

      t.timestamps null: false
    end
    
    add_column :publications, :publication_status_id, :integer, default: 0, null: false
  end
end
