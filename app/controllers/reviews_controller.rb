class ReviewsController < ApplicationController
  def new
    @review = Review.new
    @review.product = Product.find(params[:product_id])
  end

  def create
    @review = Review.new(review_params)
    @review.product = Product.find(params[:product_id])
    if @current_merchant == @review.product.merchant
      flash[:message] = "You cannot review your own products"
      redirect_to product_path(@review.product)
    elsif @review.save
      flash[:success] = "Thanks for your review!"
      redirect_to product_path(@review.product)
    else
      flash.now[:alert] = @review.errors
      render :new
    end
  end

  private

  def review_params
    params.require(:review).permit(:product_id, :rating, :description)
  end
end
