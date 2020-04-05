class AddCreatorToInstitutions < ActiveRecord::Migration
  def change
    add_column :institutions, :objectcreator, :string
  end
end
