class AddColumnsToPublication < ActiveRecord::Migration
  def change
    add_column :publications, :publish_plan, :date
    add_column :publications, :introduction, :text
    add_column :publications, :pages_multiplicity, :integer, default: 4
    add_attachment :publications, :publication_cover
    add_attachment :publications, :publication_first_page
    add_attachment :publications, :publication_second_page
    add_attachment :publications, :publication_editorial_team
    add_attachment :publications, :publication_introduction
    add_attachment :publications, :publication_thanks
    add_attachment :publications, :publication_last_page
    add_attachment :publications, :publication_cover_end
    add_attachment :publications, :publication_blank
  end
end
