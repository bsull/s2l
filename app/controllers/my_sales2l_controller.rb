class MySales2lController < ApplicationController
 
  def index
    @bookings = current_user.opportunities.where(:status => 'won')
    @forecast = current_user.opportunities.where(:status => 'forecast')
  end

end
