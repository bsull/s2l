class CustomersController < ApplicationController
  
  authorize_resource
  
  def index
    @customers = @current_account.customers.all
    respond_to do |format|
      format.js
      format.html
    end
  end

  def show
    @customer = @current_account.customers.find(params[:id])
  end

  def new
    @customer = Customer.new
  end

  def edit
    @customer = @current_account.customers.find(params[:id])
  end

  def create
    @customer = @current_account.customers.build(params[:customer])
    if @customer.save
      redirect_to(@customer, :notice => 'Customer created.')
    else
     render :action => "new"
    end
  end

  def update
    @customer = @current_account.customers.find(params[:id])
    if @customer.update_attributes(params[:customer])
      redirect_to(@customer, :notice => 'Customer updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @customer = @current_account.customers.find(params[:id])
    @customer.destroy
    redirect_to(customers_url, :notice => 'Customer destroyed.')
  end
  
  # def ac
  #   customers = @current_account.customers.where('name like ?', params[:q]+'%').all
  #   results = Array.new(customers.collect {|c| c.name})
  #   return results.join("\n")
  # end
  
end
