module HomeHelper
  
  def home_chart(account)
    
    if Time.now.utc.month <= account.fiscal_year_end
      last_year_begin = Date.new(Time.now.utc.year, account.fiscal_year_end) - 1.year - 11.months
    else
      last_year_begin = Date.new(Time.now.utc.year, account.fiscal_year_end) - 11.months
    end
    next_year_end = last_year_begin + 3.years - 1.day
    chart_begin = last_year_begin
    chart_begin += 3.months while chart_begin <= Time.now.utc.to_date - 9.months
    chart_end = chart_begin + 18.months - 1.day
    
    targets = account_targets(account, last_year_begin, next_year_end)
    bookings = account_bookings(account, last_year_begin)
    forecast = account_forecast(account, next_year_end, bookings)

    data = [] << targets << bookings << forecast << chart_begin.to_time.to_i * 1000 << chart_end.to_time.to_i * 1000
  end
  
  def account_targets(account, last_year_begin, next_year_end)  
    targets = account.account_targets.order('fiscal_year ASC')
    values = targets.collect{|t| [t.q1, t.q1+t.q2, t.q1+t.q2+t.q3, t.q1+t.q2+t.q3+t.q4]}.flatten!
    years = targets.collect{|t| Date.new(t.fiscal_year, t.account.fiscal_year_end)-11.months}
    quarters = []
    years.each{|d| quarters<<d<<d+3.months<<d+6.months<<d+9.months}
    quarters.collect!{|q| q.to_time.to_i * 1000 }
    series = []<<quarters<<values
    series.transpose
  end
  
  def account_bookings(account, last_year_begin)
    default = {}
    d = last_year_begin
    while d <= Time.now.utc.to_date
      default[d] = 0
      d+=1.month
    end    
    opportunities = account.opportunities.select('order_date, order_value').where('status = ? AND order_date >= ?', 'won', last_year_begin)
    bookings = {}
    opportunities.group_by{|o| o.order_date.beginning_of_month}.each{|k, v| bookings[k] = v.sum(&:order_value).to_i}
    monthly_bookings = default.merge(bookings).sort
    monthly_totals = monthly_bookings.collect{|b| b[1]}
    sum = 0 and last_year = monthly_totals.slice(0..11).collect{|t| (sum += t)}
    sum = 0 and this_year = monthly_totals.slice(12..monthly_totals.length).collect{|t| (sum += t)}
    x = monthly_bookings.collect{|d| d[0].to_time.to_i * 1000}
    y = last_year + this_year
    series = []<<x<<y
    series.transpose
  end
  
  def account_forecast(account, next_year_end, bookings)
    default = {}
    d = Time.now.utc.to_date.beginning_of_month
    while d < next_year_end
      default[d] = 0
      d+=1.month
    end    
    opportunities = account.opportunities.select('order_date, order_value').where('status = ? AND order_date <= ?', 'forecast', next_year_end)
    forecast = {}
    opportunities.group_by{|o| o.order_date.beginning_of_month}.each{|k, v| forecast[k] = v.sum(&:order_value).to_i}
    monthly_forecast = default.merge(forecast).sort
    monthly_totals = monthly_forecast.collect{|f| f[1]}
    sum = 0 and next_year = monthly_totals.last(12).collect{|t| (sum += t)}
    sum = bookings.flatten.last and this_year = monthly_totals.slice(0..(monthly_totals.length - 13)).collect{|t| (sum += t)}
    x = monthly_forecast.collect{|d| d[0].to_time.to_i * 1000}
    y = this_year + next_year
    series = []
    y.each_with_index{|top, i| series << [ x[i], top, top - monthly_totals[i] ] }
    return series
  end
end
