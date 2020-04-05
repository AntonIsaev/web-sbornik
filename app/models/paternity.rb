class Paternity < ActiveRecord::Base
  belongs_to :author
  belongs_to :article
  acts_as_list column: :position, scope: :article
  validates :author_id, presence: true
end
