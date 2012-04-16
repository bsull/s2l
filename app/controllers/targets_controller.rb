class TargetsController < ApplicationController
  
  before_filter :find_targetable
  
  def index
    @targets = @targetable.targets   
  end
  
  # def show
  #   @target = Target.find(params[:id])
  # end

  def new
    @target = @targetable.targets.new
  end

  def edit
    @target = @targetable.targets.find(params[:id])
  end

  def create
    @target = @targetable.targets.build(params[:target]) 
    if @target.save
      redirect_to polymorphic_path([@target.targetable, :targets])
    else
      render :action => "new"
    end
  end

  def update
    @target = @targetable.targets.find(params[:id])
    if @target.update_attributes(params[:target])
      @target.save!
      redirect_to polymorphic_path([@target.targetable, :targets])
    else
      render :action => "edit"
    end
  end

  def destroy
    @target = @targetable.targets.find(params[:id])
    @target.destroy
    redirect_to polymorphic_path([@target.targetable, :targets])
  end
  
  private  
  def find_targetable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        @parent = $1.classify.constantize.find(value)
      end
    end
    @targetable = @parent.account_check(@current_account) ? @parent : nil # Returns nil if you fiddle the URL. Not perfect.
  end

end
