class ConfidencesController < ApplicationController

  authorize_resource
  
  def index
    @confidences = @current_account.confidences.all
  end

  def show
    @confidence = @current_account.confidences.find(params[:id])
  end

  def new
    @confidence = Confidence.new(:enabled => true)
  end

  def edit
    @confidence = @current_account.confidences.find(params[:id])
  end

  def create
    @confidence = @current_account.confidences.build(params[:confidence])
    if @confidence.save
      redirect_to(@confidence, :notice => 'Confidence created.')
    else
     render :action => "new"
    end
  end

  def update
    @confidence = @current_account.confidences.find(params[:id])
    if @confidence.update_attributes(params[:confidence])
      redirect_to(@confidence, :notice => 'Confidence updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @confidence = @current_account.confidences.find(params[:id])
    @confidence.destroy
    redirect_to(confidences_url, :notice => 'Confidence destroyed.')
  end
  
end
