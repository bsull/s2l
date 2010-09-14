class UserTargetsController < ApplicationController
  
  def index
    @user_targets = @current_user.user_targets.order("fiscal_year ASC").all
  end

  def show
    @user_target = @current_user.user_targets.find(params[:id])
  end

  def new
    @user_target = UserTarget.new
  end

  def edit
    @user_target = @current_user.user_targets.find(params[:id])
  end

  def create
    @user_target = @current_user.user_targets.new(params[:user_target].merge!(params[:date])) 
    if @user_target.save
      redirect_to(user_targets_url, :notice => 'User target created.')
    else
      render :action => "new"
    end
  end

  def update
    @user_target = @current_user.user_targets.find(params[:id])
    if @user_target.update_attributes(params[:user_target].merge!(params[:date]))
      @user_target.save!
      redirect_to(user_targets_url, :notice => 'User target updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @user_target = UserTarget.find(params[:id])
    @user_target.destroy
    redirect_to(user_targets_url)
  end
  
end


