class CategoriesController < ApplicationController

  before_action :require_login, only: [:new, :create]

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = "created new category"
      redirect_to products_manager_path
    else
      flash.now[:error] = @category.errors
      render :new
    end
  end

  private

  def category_params
    params.require(:category).permit(:category_name, product_ids: [])
  end
end
