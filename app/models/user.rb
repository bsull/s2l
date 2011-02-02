class User < ActiveRecord::Base
  
  validates_presence_of :nickname, :role, :time_zone
  validates_uniqueness_of :nickname, :scope => :account_id, :case_sensitive => false
  
  belongs_to :account
  has_many :opportunities
  has_many :user_targets
  
  
  attr_accessible :email, :password, :password_confirmation, :remember_me, :nickname, :time_zone, :role, :enabled
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable :registerable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable  

  
  ROLES = %w[administrator salesman associate]
  
end
