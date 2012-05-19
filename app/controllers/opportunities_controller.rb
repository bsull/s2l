class OpportunitiesController < ApplicationController
  helper_method :sort_column, :sort_direction
  
  before_filter :setup, :except => [:index, :show]
  
  authorize_resource
  
  def index
    @opportunities = @current_account.opportunities.includes(:customer, :user).search(params).order(sort_column + " " + sort_direction).page(params[:page]).per(1)
    @salesmen = @current_account.users.where(:role => ['administrator', 'salesman'])
  end

  def show
    @opportunity = @current_account.opportunities.find(params[:id])
  end

  def new
    @opportunity = Opportunity.new
    @opportunity.status = 'lead'
    @opportunity.confidence = @confidences.last
    3.times { @opportunity.line_items.build }
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
    @products = @current_account.products.all
  end
  
  def sort_column
    %w[ customers.name name status order_value_cents updated_at users.nickname ].include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
