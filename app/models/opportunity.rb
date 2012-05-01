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
  
  before_save :set_update_requirement_and_make_fresh
  after_save :make_history
  
  accepts_nested_attributes_for :line_items, :reject_if => lambda { |a| a[:product_id].blank? }, :allow_destroy => true
  
  monetize :order_value, :as => "m_order_value", :with_currency => :usd
  
  STATUSES = %w[won lost dead forecast lead]
  
  ActiveRecord::Base.include_root_in_json = false
  
  def self.bft_chart(owner, last_year_begin, next_year_end)
    opportunities = owner.opportunities.select('order_date, order_value').where('order_date >= ? AND order_date <= ?', last_year_begin, next_year_end)
 
    # This section will prepare the bookings data series  
    bookings = opportunities.where('status =?', 'won').group_by{|o| o.order_date.beginning_of_month}
    monthly_bookings = {} and bookings.each{|k, v| monthly_bookings[k] = v.sum(&:order_value).to_i}
  
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
    series = []<<x<<y
    bookings_series = series.transpose # these are your bookings for the chart
  
    # This section will prepare the forecast data series
    forecast = opportunities.where('status =?', 'forecast').group_by{|o| o.order_date.beginning_of_month}
    monthly_forecast = {} and forecast.each{|k, v| monthly_forecast[k] = v.sum(&:order_value).to_i}

    empty_forecast = {}
    d = last_year_begin
    while d < next_year_end
      empty_forecast[d] = 0
      d+=1.month
    end
  
    monthly_forecast.merge!(empty_forecast){|k, v1, v2| v1}
    sorted_forecast = monthly_forecast.sort
    forecast_values = sorted_forecast.collect{|f| f[1]}
        
    first_period = forecast_values.first((Date.today.month - last_year_begin.month) + 12*(Date.today.year - last_year_begin.year)) # Nifty date difference in number of months
    old_forecast = [] and first_period.each_with_index{|t, i| old_forecast << (t + bookings_series[i][1])}

    sum = bookings_series.flatten.last and this_year = forecast_values.slice(first_period.length..23).collect{|t| (sum += t)}

    sum = 0 and next_year = forecast_values.last(12).collect{|t| (sum += t)}

    x = sorted_forecast.collect{|d| d[0].to_time.to_i * 1000}
    y = []<<old_forecast<<this_year<<next_year
    y.flatten!
    forecast_series = [] and y.each_with_index{|top, i| forecast_series << [ x[i], top, top - forecast_values[i] ] }
    
    return bookings_series, forecast_series
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
  
  def set_update_requirement_and_make_fresh
    self.update_requirement = (Time.now.utc.to_date + account.recent_period.days)
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