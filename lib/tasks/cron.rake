task :cron => :environment do
  puts "Checking freshness of opportunities..."
  today = Time.now.utc.to_date
  Opportunity.update_all ['stale = ?', true], ['status = ? AND (order_date < ? OR expiration_date < ?)', 'forecast', today, today]
  puts "Done."
end