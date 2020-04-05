class Author < ActiveRecord::Base
  has_many :degrees
  has_many :paternities, dependent: :destroy
  has_many :institutions, :through => :degrees
  has_many :articles, :through => :paternities
  validates :surname, presence: true
  validates :mainname, presence: true
  def name_full
    "#{surname} #{mainname} #{middlename}"
  end
  def name_full_upcase_surname
    "#{UnicodeUtils::upcase(surname)} "+"#{mainname} #{middlename}"
  end
  def name_with_initial
    if middlename.length > 0
      "#{surname}"+"\u00A0"+"#{mainname.first}.#{middlename.first}."
    else
      "#{surname}"+"\u00A0"+"#{mainname.first}."
    end  
  end  
  def full_degree
    degrees.order('position').each do |degree|
      if degree.institution != nil 
        if degree.institution.titleingenitive!= nil 
          "#{degree.info}"+" "+"#{degree.institution.titleingenitive}"+", "
        else
          "#{degree.info}"+" "+"#{degree.institution.title}"+", "
        end
      else
        "#{degree.info}"+", "
      end
    end
    
  end
  def name_with_initial_eng
    if middlename.length > 0
      "#{I18n::transliterate(mainname.first)}.#{I18n::transliterate(middlename.first)}."+"\u00A0"+"#{I18n::transliterate(surname)}"
    else
      "#{I18n::transliterate(mainname.first)}."+"\u00A0"+"#{I18n::transliterate(surname)}"
    end
  end
end
