class ForecastController < ApplicationController
  
  def index
    
    @d_max = @current_account.opportunities.where(:status => 'forecast').maximum('order_date') unless params[:search]
    
    params[:search] = {:meta_sort => 'order_date.desc'}.merge(params[:search] || {})
    @search = @current_account.opportunities.includes(:customer, :confidence, :user).where(:status => 'forecast').search(params[:search])
    @table_opportunities = @search.all
    
    @bookings = @current_account.opportunities.where(:status => 'won')
    @forecast = @current_account.opportunities.where(:status => 'forecast').search(params[:search]).relation
   
    @confidences = @current_account.confidences.all
    @salesmen = @current_account.users.where(:role => ['administrator', 'salesman'])
  end

end
