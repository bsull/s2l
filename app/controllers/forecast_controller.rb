class ForecastController < ApplicationController
  
  def index
    @search = @current_account.opportunities.where(:status => 'forecast').search(params[:search])
    @opportunities = @search.all
  end

end
