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
  
  before_save :set_update_requirement_and_make_fresh
  after_save :make_history
  
  STATUSES = %w[won lost dead forecast lead]
  
  def as_json(options={})
    ActiveRecord::Base.include_root_in_json = false
    super(:only => [:name, :order_value, :order_date])
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