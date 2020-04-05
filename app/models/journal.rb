class Journal < ActiveRecord::Base
  require 'declare_mime_constants'
  
  has_many :publications, dependent: :destroy
  has_many :articles, :through => :publications
  has_many :authors, :through => :articles
  has_many :uroles, :through => :publications
  has_attached_file :logo
  has_attached_file :arules
  validates :title, presence: true
  validates :udk, presence: true
  validates :arules, presence: true
  validates_attachment_content_type :logo, :content_type => @img_mime
  validates_attachment_content_type :arules, :content_type => @doc_mime
  
  def get_website
    if website != nil 
      return website
    else 
      return I18n.t('journals.show.no_website')
    end
  end
end
