class AddPositionToDegrees < ActiveRecord::Migration
  def change
    add_column :degrees, :position, :integer
  end
end
