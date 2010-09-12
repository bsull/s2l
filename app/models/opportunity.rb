class Opportunity < ActiveRecord::Base
  
  validates_presence_of :account_id, :user_id, :customer_id, :confidence_id, :status, :name
  validates_uniqueness_of :name, :scope => [:account_id, :customer_id], :case_sensitive => false

  belongs_to :account
  belongs_to :user
  belongs_to :customer
  belongs_to :confidence
  has_many :opportunity_records
  
  after_save :make_history
  
  STATUSES = %w[won lost dead forecast lead]
  
  protected
  
  def make_history
    today = opportunity_records.find_or_initialize_by_created_at(Time.now.utc.to_date)
    today.salesman = user.nickname
    today.order_value = order_value
    today.order_date = order_date
    today.days_to_order = order_date ? (order_date - Time.now.utc.to_date).to_i : nil
    today.confidence = confidence.name
    today.weight = confidence.weight
    today.status = status
    today.save
  end
      
end

# This is what you were using to write opportunity records when you needed a 'yesterday'
# record for charting. 
#
# def make_history
#   last_record = self.opportunity_records.order('created_at ASC').last
#   write_today and return unless last_record && last_record.created_at < Time.now.utc.to_date-1.day
#   write_yesterday(last_record)
# end
# 
# def write_today
#   today = self.opportunity_records.find_or_initialize_by_created_at(Time.now.utc.to_date)
#   today.user_id = user_id
#   today.order_value = order_value
#   today.order_date = order_date
#   today.days_to_order = order_date ? (order_date - Time.now.utc.to_date).to_i : nil
#   today.confidence = confidence.name
#   today.weight = confidence.weight
#   today.status = status
#   today.save
# end
# 
# def write_yesterday(last_record)
#   self.opportunity_records.create(:created_at => Time.now.utc.to_date-1.day) do |y|
#     y.user_id = last_record.user_id
#     y.order_value = last_record.order_value
#     y.order_date = last_record.order_date
#     y.days_to_order = last_record.order_date ? (last_record.order_date - Time.now.utc.to_date-1.day).to_i : nil
#     y.confidence = last_record.confidence
#     y.weight = last_record.weight
#     y.status = last_record.status
#   end
#   write_today
# end