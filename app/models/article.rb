class Article < ActiveRecord::Base
  has_many :materials, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :paternities, dependent: :destroy
  has_many :authors, :through => :paternities
  has_many :appointments
  belongs_to :publication
  validates :title, presence: true
  
  def full_authors
    s = ''
    authors.order('position').each do |author|
      s = s + author.name_with_initial + ', '
    end
    if s != ''
      s = s.chomp(', ')
    end
    "#{s}"
  end

  def full_authors_en
    s = ''
    authors.order('position').each do |author|
      s = s + author.name_with_initial_eng + ', '
    end
    if s != ''
      s = s.chomp(', ')
    end
    "#{s}"
  end

end
