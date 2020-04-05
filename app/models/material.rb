class Material < ActiveRecord::Base
  require 'declare_mime_constants'

  belongs_to :article
  has_one :publication, :through => :article
  acts_as_list column: :position, scope: :article
  has_attached_file :file
  has_attached_file :file_pdf
  validates_attachment_content_type :file, :content_type => @doc_mime
  validates_attachment_content_type :file_pdf, :content_type => @pdf_mime
end
