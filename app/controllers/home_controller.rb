class HomeController < ApplicationController
  
  def index
    @recent_status_changes = 
      @current_account.opportunities.where('status_change_date >= ?', @current_account.recent_period.days.ago.to_date).order("updated_at ASC").all \
      :include => [:customer, :confidence, :user]
    @recent_wins = @recent_status_changes.find_all {|o| o.status == 'won'}
    @recent_lost_or_dead = @recent_status_changes.find_all {|o| o.status == 'lost' || o.status == 'dead'}
    @recent_forecast = @recent_status_changes.find_all {|o| o.status == 'forecast'}
  end
end
