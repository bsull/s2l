class AccountTarget < ActiveRecord::Base
  
  validates_presence_of :account_id, :fiscal_year, :q1, :q2, :q3, :q4
  validates_uniqueness_of :fiscal_year, :scope => :account_id
  
  belongs_to :account
  
  def self.defaults(account)
    (1.year.ago.year..1.year.from_now.year).each do |y|
      AccountTarget.create!(:fiscal_year => y) do |t|
        t.q1 = t.q2 = t.q3 = t.q4 = 2500000
        t.account_id = account.id
      end
    end   
  end
  
end
