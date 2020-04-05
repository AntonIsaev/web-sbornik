class Comment < ActiveRecord::Base
  require 'declare_mime_constants'

  belongs_to :article
  has_one :comment_type
  has_one :publication, :through => :article
  has_attached_file :file
  validates_attachment_content_type :file, :content_type => @doc_mime
  validates :file_file_name, presence: true 
end
