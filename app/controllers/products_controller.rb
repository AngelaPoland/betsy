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
    @product = Product.find_by(id: params[:id])
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

      flash[:success] = "Successfully update your product, #{@product.id}"
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
      redirect_to products_path
    else
      if @current_cart
        @order_product = OrderProduct.new(order_id: @current_cart.id, product_id: product.id, quantity: 1, status: 'pending')
        if @order_product.save
          flash[:success] = "Successfully added product to cart"
          redirect_to order_path(@current_cart.id)
        else
          flash[:alert] = "Failed to add to cart"
          render :show
        end
      else
        session[:order_id] = Order.create.id
        @order_product = OrderProduct.new(order_id: session[:order_id], product_id: product.id, quantity: 1, status: 'pending')
        if @order_product.save
          flash[:success] = "Successfully added product to cart"
          redirect_to order_path(session[:order_id])
        else
          flash[:alert] = "Failed to add to cart"
          render :show
        end
      end
    end
  end

  def status
    status = params[:status]
    @product = Product.find_by(id: params[:id])
    @product.update_attributes(product_active: status)
    redirect_to products_manager_path
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :inventory, :photo_url, :description, categories: [])
  end

end
