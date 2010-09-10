class Status < ActiveRecord::Base
  
  validates_presence_of :name, :account_id
  validates_uniqueness_of :name, :scope => :account_id, :case_sensitive => false

  belongs_to :account
  # has_many :opportunities
  
  
  def self.defaults(account)  
    Status.create!([{:name => 'Lead',     :description => "You've just started to work on the opportunity.", :forecasted => false},
                    {:name => 'Forecast',  :description => "You think the opportunity may turn into an order.", :forecasted => true},
                    {:name => 'Won',    :description => "You got the order.", :forecasted => false},
                    {:name => 'Lost', :description => "Somebody else got the order.",  :forecasted => false},
                    {:name => 'Dead',    :description => "Nobody got the order.", :forecasted => false}]) do |a|
      a.account_id = account.id
      a.enabled = true
    end
  end
end
