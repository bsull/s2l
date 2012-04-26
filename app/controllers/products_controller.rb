class ProductsController < ApplicationController
  
  def index
    @products = @current_account.products.all
  end
  
  def show
    @product = @current_account.products.find(params[:id])
  end
  
  def new
    @product = Product.new
  end
  
  def edit
    @product = @current_account.products.find(params[:id])
  end

  def create
    @product = @current_account.products.build(params[:product])
    if @product.save
      redirect_to(@product, :notice => 'Product created.')
    else
     render :action => "new"
    end
  end
  
  def update
    @product = @current_account.products.find(params[:id])
    if @product.update_attributes(params[:product])
      redirect_to(products_url, :notice => 'Product updated.') 
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @product = @current_account.products.find(params[:id])
    @product.destroy
    redirect_to(products_url, :notice => 'Product destroyed.')
  end

end
