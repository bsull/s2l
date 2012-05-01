class LineItem < ActiveRecord::Base

  belongs_to :opportunity
  belongs_to :product
  
  monetize :value, :as => "m_value", :with_currency => :usd

end