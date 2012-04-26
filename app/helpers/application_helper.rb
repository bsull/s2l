module ApplicationHelper
  
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end
  
  def bft_chart(owner)   
    fiscal_year_end = owner.instance_of?(Account) ? owner.fiscal_year_end : owner.account.fiscal_year_end
        
    if Time.now.utc.month <= fiscal_year_end
      last_year_begin = Date.new(Time.now.utc.year, fiscal_year_end) - 1.year - 11.months
    else
      last_year_begin = Date.new(Time.now.utc.year, fiscal_year_end) - 11.months
    end
    next_year_end = last_year_begin + 3.years - 1.day
    chart_begin = last_year_begin
    chart_begin += 3.months while chart_begin <= Time.now.utc.to_date - 9.months
    chart_end = chart_begin + 18.months - 1.day
    
    bookings, forecast = Opportunity.bft_chart(owner, last_year_begin, next_year_end)

    data = [] << Target.bft_chart(owner, fiscal_year_end) << bookings << forecast << chart_begin.to_time.to_i * 1000 << chart_end.to_time.to_i * 1000
  end
  
end
