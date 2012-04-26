class ApplicationController < ActionController::Base
  
  protect_from_forgery
  layout 'red'
  
  before_filter :set_current_account
  before_filter :authenticate_user!
  
  def set_current_account
    @current_account ||= Account.find_by_subdomain(request.subdomains.last)
  end
  
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to home_url
  end
  
end

# TODO Clean out old x_targets stuff
# TODO Add products and line items for opportunities
# TODO Add catagories for opportunities
# TODO Add filters and sorts to all tables
# TODO Build opportunity detail with history
# TODO Build Journal
# TODO Work out stale strategy, cron job?
# TODO Work out 'enabled' strategy
# TODO Work out destroy strategy

