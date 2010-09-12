class Account < ActiveRecord::Base
  
  validates_presence_of :subdomain, :time_zone, :recent_period, :fiscal_year_end
  validates_format_of :subdomain, :with => /^[A-Za-z0-9-]+$/, :message => 'The subdomain can only contain alphanumeric characters and dashes.', :allow_blank => true
  validates_exclusion_of :subdomain, :in => %w( admin blog www billing help api wiki support ), :message => "That subdomain is reserved."
  validates_uniqueness_of :subdomain, :case_sensitive => false
  validates_numericality_of :recent_period, :only_integer => true
  validates_inclusion_of :recent_period, :in => 1..30, :message => "must be from 1 to 30."
  
  has_many :users
  has_many :customers
  has_many :confidences
  has_many :opportunities
  # has_many :account_targets
  
  before_save {|account| account.subdomain = account.subdomain.mb_chars.downcase.to_s}

end
