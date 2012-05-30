class Account < ActiveRecord::Base
  
  validates_presence_of :subdomain, :time_zone, :recent_period, :fiscal_year_end
  validates_format_of :subdomain, :with => /^[A-Za-z0-9-]+$/, :message => 'The subdomain can only contain alphanumeric characters and dashes.', :allow_blank => true
  validates_exclusion_of :subdomain, :in => %w( admin blog www billing help api wiki support ), :message => "That subdomain is reserved."
  validates_uniqueness_of :subdomain, :case_sensitive => false
  validates_numericality_of :recent_period, :only_integer => true
  validates_inclusion_of :recent_period, :in => 1..30, :message => "must be from 1 to 30."
  
  has_many :users
  has_many :customers
  has_many :confidences
  has_many :opportunities
  has_many :products
  has_many :targets, :as => :targetable
  
  before_save {|account| account.subdomain = account.subdomain.mb_chars.downcase.to_s}
  
  def account_check(current_account)
    id == current_account.id
  end
  
  def bft_chart(b, f, t)   
        
    if Time.now.utc.month <= fiscal_year_end
      last_year_begin = Date.new(Time.now.utc.year, fiscal_year_end) - 1.year - 11.months
    else
      last_year_begin = Date.new(Time.now.utc.year, fiscal_year_end) - 11.months
    end
    next_year_end = last_year_begin + 3.years - 1.day
    chart_begin = last_year_begin
    chart_begin += 3.months while chart_begin <= Time.now.utc.to_date - 9.months
    chart_end = chart_begin + 18.months - 1.day
    
    bookings_series, weighted_fresh_forecast, unweighted_fresh_forecast, weighted_stale_forecast, unweighted_stale_forecast = Opportunity.bft_chart(b, f, last_year_begin, next_year_end)

    data = [] << chart_begin.to_time.to_i * 1000 << chart_end.to_time.to_i * 1000 << Target.bft_chart(t, fiscal_year_end) << bookings_series << weighted_fresh_forecast << unweighted_fresh_forecast << weighted_stale_forecast << unweighted_stale_forecast
  end

end
