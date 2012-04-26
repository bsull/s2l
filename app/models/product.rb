class Product < ActiveRecord::Base
  
  belongs_to :account
  has_many :line_items
  
  def self.defaults(account)  
    Product.create!([{:name => 'Hardware',    :description => "You know, computers."},
                     {:name => 'Software',    :description => "Sometimes runs on computers."},
                     {:name => 'Services',    :description => "Sometimes needed to get software to run on hardware."},
                     {:name => 'Maintenance', :description => "Pays for bug fixes."}]) do |a|
      a.account_id = account.id
    end
  end

end
