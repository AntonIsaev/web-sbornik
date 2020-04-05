class Publication < ActiveRecord::Base
  require 'declare_mime_constants'

  has_many :articles, dependent: :destroy
  has_many :portions, dependent: :destroy
  has_many :uroles, dependent: :destroy
  has_many :comments, :through => :articles
  has_many :authors, :through => :articles
  has_many :materials, :through => :articles
  has_one :publication_status
  belongs_to :journal
  has_attached_file :website_cover
  has_attached_file :file
  validates :pubtxt, presence: true
  validates :pubno, presence: true
  validates_attachment_content_type :website_cover, :content_type => @img_mime
  validates_attachment_content_type :file, :content_type => @pdf_mime

  def title
    "#{I18n::translate('publications.show.title', pubno: pubno, pubtxt: pubtxt)}"
  end
  
  def pub_status
    "#{I18n::translate('publications.publication_statuses.id_'+publication_status_id.to_s, :default => I18n::translate('en.publications.publication_statuses.id_'+publication_status_id.to_s))}"
  end
end
