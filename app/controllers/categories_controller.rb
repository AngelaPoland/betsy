class CategoriesController < ApplicationController
  def new
    @category = Category.new
  end

  def create
    @category = Category.new
    if @current_merchant
      @category.category_name = params[:category][:category_name]
      if @category.save
        flash[:success] = "created new category"
        # needs a different path when we are further along
        redirect_to products_path
      else
        flash[:error] = @category.errors
        render :new
      end
    else
      flash[:alert] = "You need to be logged in to create a category."
    end
  end
end
