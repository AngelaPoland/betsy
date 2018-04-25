class CategoriesController < ApplicationController
  def new
    @category = Category.new
  end

  def create
    if @current_merchant
      @category = Category.new(category_params)
      if @category.save
        flash[:success] = "created new category"
        # needs a different path when we are further along
        redirect_to products_path
      else
        flash.now[:error] = @category.errors
        render :new
      end
    else
      flash[:alert] = "You need to be logged in to create a category."
      redirect_to root_path
    end
  end

  private

  def category_params
    params.require(:category).permit(:category_name, product_ids: [])
  end
end
