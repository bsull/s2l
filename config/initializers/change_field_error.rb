ActionView::Base.field_error_proc = Proc.new do |html_tag, instance_tag|
  if html_tag =~ /type="hidden"/ || html_tag =~ /<label/
    html_tag
  else
    "<span class='field_error'>#{html_tag}</span><br><span class='error_message'>#{[instance_tag.error_message].flatten.first.sub(/^\^/, '')}</span>".html_safe
  end
end
