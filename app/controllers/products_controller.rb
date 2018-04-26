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
    @merchant = Merchant.find_by(id: params[:merchant_id])
    # if @merchant.nil?
    #   flash[:alert] = "Merchant does not exist."
    #   redirect_to root_path
    # end
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    @product.merchant = @current_merchant
    @product.product_active = true
    if params[:product][:photo_url] == ""
      @product.photo_url = valid_image
    end
    if @product.save
      flash[:success] = "Successfully created product!"
      redirect_to product_path(@product.id)
    else
      flash[:error] = @product.errors
      redirect_to new_merchant_product_path(@current_merchant.id)
    end
  end

  def edit
    @merchant = Merchant.find_by(id: params[:merchant_id])
    @product = Product.find_by(id: params[:id])
    render_404 if @product.nil?
  end

  def update
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      render_404
    else
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
        redirect_to edit_merchant_product_path(@current_merchant.id, @product.id)
      end
    end
  end

  def add_to_order
    product = Product.find_by(id: params[:id])
    quantity = params[:order_products][:inventory].to_i
    if product.nil?
      flash[:alert] = "That product does not exist"
      redirect_to products_path
    elsif quantity.nil? || quantity == 0
      flash[:alert] = "We cannot add 0 products to your Cart -.-"
      redirect_to product_path(product.id)
    elsif quantity > product.inventory
      flash[:alert] = "Sorry, that amount is not available"
      redirect_to product_path(product.id)
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
