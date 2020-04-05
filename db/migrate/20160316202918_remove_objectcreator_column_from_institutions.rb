class RemoveObjectcreatorColumnFromInstitutions < ActiveRecord::Migration
  def change
    remove_column 'institutions', 'objectcreator' 
  end
end
