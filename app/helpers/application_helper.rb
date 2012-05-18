module ApplicationHelper
  
  def sortable(column, title = nil)
    title ||= column.titleize
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    indicator = column == sort_column ? sort_indicator(direction) : ''
    link_to raw(title + ' ' + indicator), params.merge(:sort => column, :direction => direction, :page => nil)
  end

  private

  def sort_indicator(direction)
    if direction == 'asc'
      '&#9660;'
    else direction == 'desc'
      '&#9650;'
    end
  end

end
