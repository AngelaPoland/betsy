require "test_helper"

describe CategoriesController do
  let(:category) { categories(:beverage) }
  let(:ange) { merchants(:ange) }

  describe "new" do

    it "successfully gets new view for form" do
      login(ange)

      get new_category_path

      must_respond_with :success
    end

    it "redirects to root view if no user has logged in" do
      get new_category_path

      must_respond_with :redirect
      must_redirect_to root_path
    end

    it "redirects to root view if a user has logged out" do
      # inspired from Media Ranker revisited
      # is this necessary?
    end

  end

  describe "create" do

    it "successfully creates a new category with valid data while logged in" do
      login(ange)
      product = Product.find_by(name: "sage")

      proc {
        post categories_path, params: { category: { category_name: "libations",
        product_ids: [product.id] }  }
      }.must_change 'Category.count', 1

      product.categories.length.must_equal 3
      must_respond_with :redirect
      must_redirect_to products_manager_path
    end

    it "successfully creates a new category without any products chosen" do
      login(ange)

      proc {
        post categories_path, params: { category: { category_name: "libations",
        product_ids: [] }  }
      }.must_change 'Category.count', 1

      must_respond_with :redirect
      must_redirect_to products_manager_path
    end

    it "will not create a new category with bogus data" do
      login(ange)
      product = Product.find_by(name: "sage")

      proc {
        post categories_path, params: { category: { category_name: " ",
        product_ids: [product.id]   }  }
      }.wont_change 'Category.count'

      product.categories.length.must_equal 2
      must_respond_with :error
    end

    it "doesn't add new category to products that do not belong to current user" do
      login(ange)
      product = Product.find_by(name: "kombucha")

      proc {
        post categories_path, params: { category: { category_name: "libations",
        product_ids: [product.id] }  }
      }.must_change 'Category.count', 1

      product.categories.length.must_equal 2
      must_respond_with :redirect
      must_redirect_to products_manager_path
    end

    it "redirects to root view if no user present and doesn't save to model" do
      product = Product.find_by(name: "sage")

      proc {
        post categories_path, params: { category: { category_name: "libations",
        product_ids: [product.id]   }  }
      }.wont_change 'Category.count'

      product.categories.length.must_equal 2
      must_respond_with :redirect
      must_redirect_to root_path
    end

  end
end
