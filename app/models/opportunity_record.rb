class OpportunityRecord < ActiveRecord::Base
  
  belongs_to :opportunity
  
  monetize :order_value_cents
  
end
