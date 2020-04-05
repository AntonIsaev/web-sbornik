class Institution < ActiveRecord::Base
  has_many :degrees
  has_many :authors, :through => :degrees
  validates :title, presence: true
  validates :postaddress, presence: true
end
