class UsersController < ApplicationController
  skip_before_filter :authenticate_user!
  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to(@user, :notice => 'User was successfully created.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
  
  def sign_up
    redirect_to users_url unless @current_account.users.empty?
    if request.post?
      @user = @current_account.users.build(params[:user])
      @user.role = 'administrator'
      @user.time_zone = "Central Time (US & Canada)"
      if @user.save
        # UserTarget.defaults(@user)
        sign_in :user, @user # session[:user_id] = @user.id
        redirect_to(accounts_url, :notice => "Welcome, you're signed up & signed in.")
      end
    else
      @user = User.new
    end
  end
  
  def change_profile
    if request.post?
      @user = @current_user
      if @user.update_attributes(params[:user])
        redirect_to(@user, :notice => 'Profile updated.')
      else
        render :action => "change_profile"
      end    
    else
      @user = @current_user
    end
  end

end
