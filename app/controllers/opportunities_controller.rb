class OpportunitiesController < ApplicationController
  
  before_filter :setup, :except => [:index, :show]
  
  authorize_resource
  
  def index
    @opportunities = @current_account.opportunities.all
  end

  def show
    @opportunity = @current_account.opportunities.find(params[:id])
  end

  def new
    @opportunity = Opportunity.new
    @opportunity.status = 'lead'
    @opportunity.confidence = @confidences.last
  end

  def edit
    @opportunity = @current_account.opportunities.find(params[:id])
  end

  def create
    @opportunity = @current_account.opportunities.build(params[:opportunity])
    @opportunity.user = @current_user
    @opportunity.customer = @current_account.customers.find_or_create_by_name(params[:customer][:name])
    @opportunity.status_change_date = Time.now.utc.to_date
    if @opportunity.save
      redirect_to(opportunities_url, :notice => 'Opportunity created.')
    else
      render :action => "new"
    end
  end

  def update
    @opportunity = @current_account.opportunities.find(params[:id])
    @opportunity.customer = @current_account.customers.find_or_create_by_name(params[:customer][:name])
    @opportunity.status_change_date = Time.now.utc.to_date unless @opportunity.status == params[:opportunity][:status] 
    if @opportunity.update_attributes(params[:opportunity])
      redirect_to(opportunities_url, :notice => 'Opportunity updated.') 
    else
      render :action => "edit"
    end
  end

  def destroy
    @opportunity = @current_account.opportunities.find(params[:id])
    @opportunity.destroy
    redirect_to opportunities_url
  end
  private
  
  def setup
    @confidences = @current_account.confidences.where(:enabled => true).order("weight DESC").all
  end
  
end
