class AddWebsiteCoverToPublications < ActiveRecord::Migration
  def change
    add_attachment :publications, :website_cover
  end
end
