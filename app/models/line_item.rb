class LineItem < ActiveRecord::Base

  belongs_to :opportunity
  belongs_to :product


end