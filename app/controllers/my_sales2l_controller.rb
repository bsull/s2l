class MySales2lController < ApplicationController
 
  def index
    @bookings = @current_account.opportunities.where(:status => 'won')
    @forecast = @current_account.opportunities.where(:status => 'forecast')
  end

end
