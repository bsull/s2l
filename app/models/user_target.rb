class UserTarget < ActiveRecord::Base
  
  validates_presence_of :user_id, :fiscal_year, :q1, :q2, :q3, :q4
  validates_uniqueness_of :fiscal_year, :scope => :user_id
  
  belongs_to :user
  
  def self.defaults(user)
    (1.year.ago.year..1.year.from_now.year).each do |y|
      UserTarget.create!(:fiscal_year => y) do |t|
        t.q1 = t.q2 = t.q3 = t.q4 = 500000
        t.user_id = user.id
      end
    end   
  end
end
