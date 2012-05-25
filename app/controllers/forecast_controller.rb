class ForecastController < ApplicationController
  
    helper_method :sort_column, :sort_direction
  
  def index   
    @opportunities = @current_account.opportunities.includes(:customer, :confidence, :user).where(:status => 'forecast').search(params).order(sort_column + " " + sort_direction).page(params[:page])
    
    @bookings = @current_account.opportunities.where(:status => 'won')
    # @forecast = @current_account.opportunities.where(:status => 'forecast').search(params)
   
    @confidences = @current_account.confidences.order("weight DESC")
    @salesmen = @current_account.users.where(:role => ['administrator', 'salesman'])
  end
  
  private 
  
  def sort_column
    %w[ customers.name name order_value_cents order_date confidences.name users.nickname ].include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
