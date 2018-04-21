class ProductsController < ApplicationController

  def root
  end

  def index
    @categories = Category.order(:category_name)

    if params[:category_id]
      if Category.find_by(id: params[:category_id]).nil?
        render_404
      else
        @products = Product.includes(:categories).where(product_active: true, categories: { id: params[:category_id]})
      end
    elsif params[:merchant_id]
      if Merchant.find_by(id: params[:merchant_id]) == nil
        render_404
      else
        @products = Product.includes(:merchant).where(product_active: true, products: {merchant_id: params[:merchant_id]})
      end
    # elsif params[:search]
    #     @products = Product.search(params[:search]).order(:name)
    else
      @products = Product.where(product_active: true).order(:id)
    end
  end

  def show
  end

  def new
    @product = Product.new
    @merchant = Merchant.find_by(id: params[:merchant_id])
  end

  def create
    @product = Product.new(product_params)
    @product.merchant = Merchant.find_by(id: params[:merchant_id])
    @product.product_active = true
    if @product.save
      flash[:success] = "Successlfully created product!"
      redirect_to product_path(@product.id)
    else
      flash.now[:error] = @product.errors
      render :new
    end
  end

  def edit
    @product = Product.find_by(id: params[:id])
    @merchant = Merchant.find_by(id: params[:merchant_id])
  end

  def update
    @product = Product.find_by(id: params[:id])
    if @product.update(product_params)
    end
  end

  def add_to_order
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :inventory, :photo_url, :description, categories: [])
  end

end
