require "test_helper"

describe CategoriesController do
  let(:category) { categories(:beverage) }

  describe "new" do

    it "succeeds" do
      get new_category_path
      must_respond_with :success
    end

  end

  describe "create" do

    it "creates a new category with valid data" do
      proc {
        post categories_path, params: { category: { category_name: "libations" }  }
      }.must_change 'Category.count', 1

      must_respond_with :redirect
      must_redirect_to categories_path

    end

  end
end
