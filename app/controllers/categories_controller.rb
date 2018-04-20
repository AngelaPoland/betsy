class CategoriesController < ApplicationController
  def new
    @category = Category.new
  end

  def create
    @category = Category.new
    # needs to validate that a current merchant is present
    # add if statement for Merchant
    @category.category_name = params[:category][:category_name]
    if @category.save
      flash[:success] = "created new category"
      # needs a different path when we are further along
      redirect_to products_path
    else
      flash[:error] = @category.errors
      render :new
    end
  end
end
