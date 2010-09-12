class Customer < ActiveRecord::Base

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :account_id, :case_sensitive => false

  belongs_to :account
  has_many :opportunities
  

end
