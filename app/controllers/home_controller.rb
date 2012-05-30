class HomeController < ApplicationController
  
  def index
    @opportunities = @current_account.opportunities
    @bookings = @opportunities.where(:status => 'won')
    @forecast = @opportunities.where(:status => 'forecast')
    @recent_status_changes = @opportunities.includes(:customer, :user).where('status_change_date >= ?', @current_account.recent_period.days.ago.to_date).order("updated_at ASC").all
    @stale = @forecast.includes(:customer, :user).where(:stale => true)
    @recent_wins = @recent_status_changes.find_all {|o| o.status == 'won'}
    @recent_losses = @recent_status_changes.find_all {|o| o.status == 'lost'}
    @recent_dead = @recent_status_changes.find_all {|o| o.status == 'dead'}
    @recent_forecast = @recent_status_changes.find_all {|o| o.status == 'forecast'}
  end
end
