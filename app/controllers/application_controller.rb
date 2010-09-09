class ApplicationController < ActionController::Base
  
  protect_from_forgery
  layout 'golden'
  
  before_filter :set_current_account
  before_filter :authenticate_user!
  
  def set_current_account
    @current_account ||= Account.find_by_subdomain(request.subdomains.last)
  end

end
