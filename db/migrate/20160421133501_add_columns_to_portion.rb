class AddColumnsToPortion < ActiveRecord::Migration
  def change
    add_column :portions, :pages_count, :integer, default: '0'
    add_attachment :portions, :file_pdf
  end
end
