class Degree < ActiveRecord::Base
  belongs_to :author
  belongs_to :institution
  validates :info, presence: true
end
