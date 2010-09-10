class StatusesController < ApplicationController
  
  authorize_resource
  
  def index
    @statuses = @current_account.statuses.all
  end

  def show
    @status = @current_account.statuses.find(params[:id])
  end

  def new
    @status = Status.new(:enabled => true)
  end

  def edit
    @status = @current_account.statuses.find(params[:id])
  end

  def create
    @status = @current_account.statuses.build(params[:status])
    if @status.save
      redirect_to(@status, :notice => 'Status created.')
    else
     render :action => "new"
    end
  end

  def update
    @status = @current_account.statuses.find(params[:id])
    if @status.update_attributes(params[:status])
      redirect_to(@status, :notice => 'Status updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @status = @current_account.statuses.find(params[:id])
    @status.destroy
    redirect_to(statuses_url, :notice => 'Status destroyed.')
  end
end
