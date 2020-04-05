class Portion < ActiveRecord::Base
  require 'declare_mime_constants'

  belongs_to :publication
  has_one :portion_type
  acts_as_list column: :position, scope: :publication
  has_attached_file :file
  validates_attachment_content_type :file, :content_type => @doc_img_mime
  has_attached_file :file_pdf
  validates_attachment_content_type :file_pdf, :content_type => @pdf_mime
end
