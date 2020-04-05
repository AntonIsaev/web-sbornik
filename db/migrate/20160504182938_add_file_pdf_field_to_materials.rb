class AddFilePdfFieldToMaterials < ActiveRecord::Migration
  def change
    add_attachment :materials, :file_pdf
  end
end
