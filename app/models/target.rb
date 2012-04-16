class Target < ActiveRecord::Base
  
  validates_presence_of :targetable_id, :targetable_type, :fiscal_year, :q1, :q2, :q3, :q4
  validates_numericality_of :fiscal_year, :q1, :q2, :q3, :q4, :only_integer => true
  validates_uniqueness_of :fiscal_year, :scope => [ :targetable_id, :targetable_type]
  
  belongs_to :targetable, :polymorphic => true
  
  def self.defaults(target_owner, quarterly_amount)
    (1.year.ago.year..1.year.from_now.year).each do |y|
      target_owner.targets.create!(:fiscal_year => y) do |t|
        t.q1 = t.q2 = t.q3 = t.q4 = quarterly_amount
      end
    end   
  end
  
  # TODO check to see if this breaks when you're missing a target in the middle of a date range
  def self.bft_chart(owner, fiscal_year_end)  
    targets = owner.targets.order('fiscal_year ASC')
    values = targets.collect{|t| [t.q1, t.q1+t.q2, t.q1+t.q2+t.q3, t.q1+t.q2+t.q3+t.q4]}.flatten!
    years = targets.collect{|t| Date.new(t.fiscal_year, fiscal_year_end)-11.months}
    quarters = []
    years.each{|d| quarters<<d<<d+3.months<<d+6.months<<d+9.months}
    values.push(values.last) and quarters.push(quarters.last + 3.months) # charting hack to ensure last quarter will draw.
    quarters.collect!{|q| q.to_time.to_i * 1000 }
    series = []<<quarters<<values
    series.transpose
  end
  
end
