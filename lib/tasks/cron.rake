task :cron => :environment do
  puts "Checking freshness of opportunities"
  today = Time.now.utc.to_date
  Opportunity.update_all ['stale = ?', true], ['status = ? AND (order_date < ? OR update_requirement < ?)', 'forecast', today, today]
  puts "Finished checking freshness"
end