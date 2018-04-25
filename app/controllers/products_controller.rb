class ProductsController < ApplicationController

  before_action :require_login, only: [:new, :create, :edit, :update, :product_status]
  before_action :confirm_current_merchant, only: [:new, :create, :edit, :update, :product_status]

  def root
    active = Product.where(product_active: true)
    if active.count < 10
      i = active.length
      @staff_picks = active.sample(i)
    else
      @staff_picks = active.sample(10)
    end
    @top_rated = active.sort_by {|p| p.average_rating}
    @top_rated = @top_rated[0..9]
  end

  def index
    if params[:category_id]
      if Category.find_by(id: params[:category_id]).nil?
        render_404
      else
        @products = Product.includes(:categories).where(product_active: true, categories: { id: params[:category_id]})
      end
    elsif params[:merchant_id]
      if Merchant.find_by(id: params[:merchant_id]).nil?
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
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      flash[:alert] = "That product does not exist"
      redirect_to products_path
    end
  end

  def new
    @product = Product.new
    @merchant = Merchant.find_by(id: params[:merchant_id])
  end

  def create
    @product = Product.new(product_params)
    @product.merchant = @merchant.id

    @product.product_active = true
    if params[:product][:photo_url] == ""
      @product.photo_url = valid_image
    end
    if @product.save
      flash[:success] = "Successfully created product!"
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
    if @product.photo_url.empty? && params[:product][:photo_url].empty?
      @product.photo_url = valid_image
    elsif params[:product][:photo_url] != ""
      @product.photo_url = params[:product][:photo_url]
    else
      @product.photo_url = @product.photo_url
    end
    if @product.update(product_params)
      flash[:success] = "Successfully updated your product:  #{@product.name}"
      redirect_to product_path(@product.id)
    else
      flash[:error] = @product.errors
      render :edit
    end
  end

  def add_to_order
    product = Product.find_by(id: params[:id])
    if product.nil?
      flash[:alert] = "That product does not exist"
      redirect_to products_path
    elsif product.merchant == @current_merchant
      flash[:alert] = "This is your product"
      redirect_to products_path
    elsif product.product_active == false
      flash[:alert] = "That product is currently retired"
      redirect_to products_path
    elsif product.inventory < 1
      flash[:alert] = "That product is out of stock."
      render :show
    else
      if @current_cart
        @order_product = OrderProduct.new(order_id: @current_cart.id, product_id: product.id, quantity: params[:order_products][:inventory], status: 'pending')
        if @order_product.save
          product.inventory -= params[:order_products][:inventory].to_i
          product.save
          flash[:success] = "Successfully added product to cart"
          redirect_to product_path(product.id)
          # redirect_to order_path(@current_cart.id)
        else
          flash[:alert] = "Failed to add to cart"
          render :show
        end
      else
        session[:order_id] = Order.create.id
        @order_product = OrderProduct.new(order_id: session[:order_id], product_id: product.id, quantity: params[:order_products][:inventory], status: 'pending')
        if @order_product.save
          product.inventory -= params[:order_products][:inventory].to_i
          product.save
          flash[:success] = "Successfully added product to cart"
          redirect_to product_path(product.id)
          # redirect_to order_path(session[:order_id])
        else
          flash[:alert] = "Failed to add to cart"
          render :show
        end
      end
    end
  end

  def product_status
    status = params[:product_active]
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      redirect_to account_page_path
    else
      @product.update_attributes(product_active: status)
      redirect_to products_manager_path
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :inventory, :photo_url, :description, category_ids: [], categories_attributes: [:category_name])
  end

  def valid_image
    "placeholder.jpg"
  end

end
