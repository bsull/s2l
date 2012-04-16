class UsersController < ApplicationController
  
  skip_before_filter :authenticate_user!, :only => :sign_up
  
  def index
    @search = @current_account.users.search(params[:search])
    @users = params[:search] ? @search.all : @current_account.users.order("nickname ASC")
  end

  def show
    @user = @current_account.users.find(params[:id])
  end

  def new
    @user = User.new(:enabled => true, :role => 'associate')
  end

  def edit
    @user = @current_account.users.find(params[:id])
  end

  def create
    @user = @current_account.users.build(params[:user])
    if @user.save
      redirect_to users_url
    else
      flash['error'] = "User couldn't be saved."
      render :action => "new"
    end
  end

  def update
    @user = @current_account.users.find(params[:id])
      if @user.update_attributes(params[:user])
        redirect_to users_url
      else
        flash['error'] = "User couldn't be updated."
        render :action => "edit"
      end
  end

  def destroy
    @user = @current_account.users.find(params[:id])
    @user.destroy
    redirect_to users_url
  end
  
  def sign_up
    redirect_to users_url and return unless @current_account.users.empty?
    if request.post?
      @user = @current_account.users.build(params[:user])
      @user.role = 'administrator'
      @user.enabled = true
      if @user.save
        Target.defaults(@user, 500000)
        sign_in :user, @user # session[:user_id] = @user.id
        redirect_to home_url
      else
        flash['error'] = "Let's try again."
        render :action => 'sign_up'
      end
    else
      @user = User.new
    end
  end
  
  def edit_profile
    if request.post?
      @user = current_user
      if @user.update_attributes(params[:user])
        redirect_to @user 
      else
        flash['error'] = "Let's try again."
        render :action => "edit_profile"
      end    
    else
      @user = current_user
    end
  end
  
  def change_password
    if request.post?
      @user = current_user
      if @user.update_attributes(params[:user])
        redirect_to @user 
      else
        flash['error'] = "Let's try again."
        render :action => "change_password"
      end    
    else
      @user = current_user
    end
  end

end
