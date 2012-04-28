class ForecastController < ApplicationController
  
  def index
    params[:search] = {:meta_sort => 'order_date.desc'}.merge(params[:search] || {})
    @search = @current_account.opportunities.includes(:customer, :confidence, :user).where(:status => 'forecast').search(params[:search])
    @opportunities = @search.all
  end

end
