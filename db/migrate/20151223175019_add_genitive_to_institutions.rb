class AddGenitiveToInstitutions < ActiveRecord::Migration
  def change
    add_column :institutions, :titleingenitive, :string
    add_column :institutions, :checkedbyadmin, :boolean
  end
end
