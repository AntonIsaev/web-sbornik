class RemoveAttachmentColumnsFromPublications < ActiveRecord::Migration
  def change
    remove_attachment :publications, :publication_cover
    remove_attachment :publications, :publication_first_page
    remove_attachment :publications, :publication_second_page
    remove_attachment :publications, :publication_editorial_team
    remove_attachment :publications, :publication_introduction
    remove_attachment :publications, :publication_thanks
    remove_attachment :publications, :publication_last_page
    remove_attachment :publications, :publication_cover_end
    remove_attachment :publications, :publication_blank
  end
end
