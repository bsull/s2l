class Opportunity < ActiveRecord::Base
    
  validates_presence_of :status, :name
  validates_presence_of :order_value, :if => "status == 'forecast'"
  validates_associated :customer, :confidence
  validates_uniqueness_of :name, :scope => [:account_id, :customer_id], :case_sensitive => false
  validate :forecasted_order_dates
  
  belongs_to :account
  belongs_to :user
  belongs_to :customer
  belongs_to :confidence
  has_many :opportunity_records
  has_many :line_items, :dependent => :destroy
  has_many :products, :through => :line_items
  
  before_save :set_expiration_date_and_make_fresh
  after_save :make_history
  
  accepts_nested_attributes_for :line_items, :reject_if => lambda { |a| a[:product_id].blank? }, :allow_destroy => true
  
  monetize :order_value_cents
  
  STATUSES = %w[won lost dead forecast lead]
  
  ActiveRecord::Base.include_root_in_json = false
  
  def weighted_order_value_cents
    order_value_cents * confidence.weight / 100
  end
  
  def self.search(params)
      search = scoped
      search = search.joins(:customer).where('customers.name LIKE ?', "%#{params[:customer]}%") if params[:customer].present?
      search = search.where('opportunities.name LIKE ?', "%#{params[:name]}%") if params[:name].present?
      search = search.where('opportunities.order_value_cents >= ?', params[:min_order_value].to_money.cents) if params[:min_order_value].present?
      search = search.where('opportunities.order_value_cents <= ?', params[:max_order_value].to_money.cents) if params[:max_order_value].present?
      search = search.where('opportunities.order_date >= ?', params[:min_order_date]) if params[:min_order_date].present?
      search = search.where('opportunities.order_date <= ?', params[:max_order_date]) if params[:max_order_date].present?
      search = search.where(:status => params[:status]) if params[:status].present?
      search = search.where(:confidence_id => params[:confidence]) if params[:confidence].present?
      search = search.where(:user_id => params[:owner]) if params[:owner].present?   
      search
  end
  
  def self.bft_chart(b, f, last_year_begin, next_year_end)
 
    # This section will prepare the bookings data series  
    bookings = b.where('order_date >= ? AND order_date <= ?', last_year_begin, next_year_end).group_by{|o| o.order_date.beginning_of_month}
    monthly_bookings = {} and bookings.each{|k, v| monthly_bookings[k] = v.sum(&:order_value_cents)}
      
    empty_bookings = {}
    d = last_year_begin
    while d <= Time.now.utc.to_date
      empty_bookings[d] = 0
      d+=1.month
    end
    
    monthly_bookings.merge!(empty_bookings){|k, v1, v2| v1}
    sorted_bookings = monthly_bookings.sort
    bookings_values = sorted_bookings.collect{|b| b[1]}
    
    # accumulated monthly totals  
    sum = 0 and last_year = bookings_values.slice(0..11).collect{|t| (sum += t)}
    sum = 0 and this_year = bookings_values.slice(12..monthly_bookings.length).collect{|t| (sum += t)}
    
    x = sorted_bookings.collect{|d| d[0].to_time.to_i * 1000}
    y = last_year + this_year
    y.collect!{|b| b/100 }
    series = []<<x<<y
    bookings_series = series.transpose #these are your bookings for the chart
  
    # This section will prepare the forecast data series
    fresh_forecast = f.where('order_date >= ? AND order_date <= ? AND stale = ?', last_year_begin, next_year_end, false).group_by{|o| o.order_date.beginning_of_month}
    stale_forecast = f.where('order_date >= ? AND order_date <= ?', last_year_begin, next_year_end).group_by{|o| o.order_date.beginning_of_month}
    
    monthly_weighted_fresh = {} and fresh_forecast.each{|k, v| monthly_weighted_fresh[k] = v.sum(&:weighted_order_value_cents)}
    monthly_unweighted_fresh = {} and fresh_forecast.each{|k, v| monthly_unweighted_fresh[k] = v.sum(&:order_value_cents)}
    monthly_weighted_stale = {} and stale_forecast.each{|k, v| monthly_weighted_stale[k] = v.sum(&:weighted_order_value_cents)}
    monthly_unweighted_stale = {} and stale_forecast.each{|k, v| monthly_unweighted_stale[k] = v.sum(&:order_value_cents)}
    
    weighted_fresh_forecast = forecast_for_chart(monthly_weighted_fresh, last_year_begin, next_year_end, bookings_series)
    unweighted_fresh_forecast = forecast_for_chart(monthly_unweighted_fresh, last_year_begin, next_year_end, bookings_series)
    weighted_stale_forecast = forecast_for_chart(monthly_weighted_stale, last_year_begin, next_year_end, bookings_series)
    unweighted_stale_forecast = forecast_for_chart(monthly_unweighted_stale, last_year_begin, next_year_end, bookings_series)
    
    return bookings_series, weighted_fresh_forecast, unweighted_fresh_forecast, weighted_stale_forecast, unweighted_stale_forecast
  end
  
  def self.forecast_for_chart(monthly_forecast, last_year_begin, next_year_end, bookings_series)
    empty_forecast = {}
    d = last_year_begin
    while d < next_year_end
      empty_forecast[d] = 0
      d+=1.month
    end
  
    monthly_forecast.merge!(empty_forecast){|k, v1, v2| v1}
    sorted_forecast = monthly_forecast.sort
    forecast_values = sorted_forecast.collect{|f| f[1]/100}
        
    first_period = forecast_values.first((Date.today.month - last_year_begin.month) + 12*(Date.today.year - last_year_begin.year)) # Nifty date difference in number of months
    old_forecast = [] and first_period.each_with_index{|t, i| old_forecast << (t + bookings_series[i][1])}

    sum = bookings_series.flatten.last and this_year = forecast_values.slice(first_period.length..23).collect{|t| (sum += t)}

    sum = 0 and next_year = forecast_values.last(12).collect{|t| (sum += t)}

    x = sorted_forecast.collect{|d| d[0].to_time.to_i * 1000}
    y = []<<old_forecast<<this_year<<next_year
    y.flatten!
    series = [] and y.each_with_index{|top, i| series << [ x[i], top, top - forecast_values[i] ] }
    return series
  end
            
  protected
  
  # TODO Figure out how to work with the account's time zone to validate forecast dates.
  
  def forecasted_order_dates
    if status == 'forecast' and order_date.nil?
      errors.add(:order_date, "must be present if Status is Forecast")
    elsif status == 'forecast' and order_date < Time.now.utc.to_date
      errors.add(:order_date, "can't be in the past")
    end        
  end
  
  def set_expiration_date_and_make_fresh
    self.expiration_date = (Time.now.utc.to_date + account.recent_period.days)
    self.stale = 'false'
  end
  
  def make_history
    today = opportunity_records.find_or_initialize_by_created_at(Time.now.utc.to_date)
    today.salesman = user.nickname
    today.order_value = order_value
    today.order_date = order_date
    today.days_to_order = order_date ? (order_date - Time.now.utc.to_date).to_i : nil
    today.confidence = confidence.name
    today.weight = confidence.weight
    today.status = status.humanize
    today.save
  end
      
end