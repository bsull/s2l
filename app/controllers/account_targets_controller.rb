class AccountTargetsController < ApplicationController
  
  def index
    @account_targets = @current_account.account_targets.order("fiscal_year ASC").all
  end

  def show
    @account_target = @current_account.account_targets.find(params[:id])
  end

  def new
    @account_target = AccountTarget.new
  end

  def edit
    @account_target = @current_account.account_targets.find(params[:id])
  end

  def create
    @account_target = @current_account.account_targets.new(params[:account_target]) 
    if @account_target.save
      redirect_to(account_targets_url, :notice => 'Account target created.')
    else
      render :action => "new"
    end
  end

  def update
    @account_target = @current_account.account_targets.find(params[:id])
    if @account_target.update_attributes(params[:account_target])
      @account_target.save!
      redirect_to(account_targets_url, :notice => 'Account target updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @account_target = AccountTarget.find(params[:id])
    @account_target.destroy
    redirect_to(account_targets_url)
  end
  
end


