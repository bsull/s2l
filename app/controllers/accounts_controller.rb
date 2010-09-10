class AccountsController < ApplicationController
  
  skip_before_filter :authenticate_user!, :only => [:new, :create]
  
  def index
    @accounts = Account.all
  end

  def show
    @account = Account.find(params[:id])
  end

  def new
    @account = Account.new
  end

  def edit
    @account = Account.find(params[:id])
  end

  def create
    @account = Account.new(params[:account])
    @account.time_zone = "Central Time (US & Canada)"
    @account.recent_period = 10
    @account.fiscal_year_end = 12
    if @account.save
      Confidence.defaults(@account)
      Status.defaults(@account)
      # AccountTarget.defaults(@account)
      redirect_to request.protocol+@account.subdomain+"."+request.domain+request.port_string+sign_up_path
    else
      render :action => "new"
    end
  end
  
  def update
    @account = Account.find(params[:id])
    if @account.update_attributes(params[:account].merge!(params[:date]))
      redirect_to(@account, :notice => 'Account updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @account = Account.find(params[:id])
    @account.destroy
    redirect_to(accounts_url)
  end
  
  def change_settings
    if request.post?
      @account = @current_account
      if @account.update_attributes(params[:account].merge!(params[:date]))
        redirect_to(@account, :notice => 'Account updated.')
      else
        render :action => "settings"
      end    
    else
      @account = @current_account
    end
  end

end









