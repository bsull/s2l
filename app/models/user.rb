class User < ActiveRecord::Base
  
  validates_presence_of :nickname, :role, :time_zone
  validates_uniqueness_of :nickname, :scope => :account_id, :case_sensitive => false
  
  belongs_to :account
  
  attr_accessible :email, :password, :password_confirmation, :remember_me, :nickname, :time_zone, :role
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable :registerable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable  

  
  ROLES = %w[associate salesman administrator]
  
end
