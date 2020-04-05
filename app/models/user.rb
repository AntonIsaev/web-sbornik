class User < ActiveRecord::Base
  include TheRole::Api::User
  acts_as_messageable
  
  has_one :author
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :registerable,
         :confirmable,
         :recoverable, 
         :rememberable, 
         :trackable, 
         :validatable,
         :omniauthable
         
  # ROLES = %w[admin(1) author(2) proofreader(3) chief_assistant(4) chief(5)]
  def display_name
    "#{username}"
  end
  
  def mailboxer_email(object)
    "#{email}"
  end
end
